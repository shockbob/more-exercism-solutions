package forth

import (
	"errors"
	"strconv"
	"strings"
)

type WordDefinition struct {
	word       string
	definition []string
}

type Operation struct {
	word            string
	stackSizeNeeded int
	what            func(stack []int) ([]int, error)
}

func divide(stack []int) ([]int, error) {
	a := stack[len(stack)-1]
	if a == 0 {
		return nil, errors.New("Divide by zero")
	}
	b := stack[len(stack)-2]
	return append(stack[0:len(stack)-2], b/a), nil
}


var operations = []Operation{
	{"+", 2, func(stack []int) ([]int, error) { return append(stack[:len(stack)-2], stack[len(stack)-1]+stack[len(stack)-2]), nil }},
	{"-", 2, func(stack []int) ([]int, error) { return append(stack[:len(stack)-2], stack[len(stack)-2]-stack[len(stack)-1]), nil }},
	{"*", 2, func(stack []int) ([]int, error) { return append(stack[:len(stack)-2], stack[len(stack)-1]*stack[len(stack)-2]), nil }},
	{"/", 2, divide},
	{"dup", 1, func(stack []int) ([]int, error) { return append(stack, stack[len(stack)-1]), nil }},
	{"drop", 1, func(stack []int) ([]int, error) { return stack[0 : len(stack)-1], nil }},
	{"swap", 2, func(stack []int) ([]int, error) { return append(stack[:len(stack)-2], stack[len(stack)-1], stack[len(stack)-2]), nil }},
	{"over", 2, func(stack []int) ([]int, error) { return append(stack, stack[len(stack)-2]), nil }},
}

func findCustomWord(word string, customWords []WordDefinition) (int, bool) {
	if customWords != nil {
		for customIndex := range customWords {
			if customWords[customIndex].word == strings.ToLower(word) {
				return customIndex, true
			}
		}
	}
	return -1, false
}
func defineNewWord(wordIndex int, customWords []WordDefinition, words []string) (int, []WordDefinition, error) {
	var definition []string
	wordIndex++
	wordName := strings.ToLower(words[wordIndex])
	_, err := strconv.ParseInt(wordName, 10, 16)
	if err == nil {
		return 0, nil, errors.New("Don't redefine ints")
	}
	wordIndex++
	for words[wordIndex] != ";" {
		customIndex, found := findCustomWord(words[wordIndex], customWords)
		if found {
			definition = append(definition, customWords[customIndex].definition...)
		} else {
			definition = append(definition, words[wordIndex])
		}
		wordIndex++
	}
	wordIndex++
	customIndex, found := findCustomWord(wordName, customWords)
	if found {
		customWords[customIndex].definition = definition
	} else {
		customWords = append(customWords, WordDefinition{wordName, definition})
	}
	return wordIndex, customWords, nil
}

func interpret(word string, customWords []WordDefinition, stack []int) ([]int, error) {
	word = strings.ToLower(word)
	value, err := strconv.ParseInt(word, 10, 16)
	if err == nil {
		stack = append(stack, int(value))
		return stack, nil
	} else {
		customIndex, found := findCustomWord(word, customWords)
		if found {
			definition := customWords[customIndex].definition
			for definitionIndex := range definition {
				var err error
				stack, err = interpret(definition[definitionIndex], customWords, stack)
				if err != nil {
					return nil, err
				}
			}
			return stack, nil
		}
	}
	for operationIndex := range operations {
		operation := operations[operationIndex]
		if operation.word == word {
			if len(stack) < operation.stackSizeNeeded {
				return nil, errors.New("Stack underflow during operation " + word)
			}
			var err error
			stack, err = operation.what(stack)
			if err == nil {
				return stack, nil
			} else {
				return nil, err
			}
		}
	}

	return nil, errors.New("Word not found")
}

func Forth(input []string) ([]int, error) {
	var customWords []WordDefinition
	var stack []int
	var words []string
	for inputIndex := range input {
		inputWords := strings.Split(input[inputIndex], " ")
		words = append(words, inputWords...)
	}
	wordIndex := 0
	for wordIndex < len(words) {
		word := strings.ToLower(words[wordIndex])
		if word == ":" {
			var err error
			wordIndex, customWords, err = defineNewWord(wordIndex, customWords, words)
			if err != nil {
				return nil, err
			}
		} else {
			var err2 error
			stack, err2 = interpret(word, customWords, stack)
			if err2 != nil {
				return nil, err2
			}
			wordIndex++
		}
	}
	return stack, nil
}
