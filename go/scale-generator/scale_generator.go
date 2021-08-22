package scale

import "strings"

const FLAT = 1
const SHARP = 0

var types = map[string]int{
	"C": SHARP, "G": SHARP, "D": SHARP, "A": SHARP, "E": SHARP, "B": SHARP, "F#": SHARP,
	"e": SHARP, "b": SHARP, "f#": SHARP, "c#": SHARP, "g#": SHARP, "d#": SHARP,
	"F": FLAT, "Bb": FLAT, "Eb": FLAT, "Ab": FLAT, "Db": FLAT,
	"d": FLAT, "g": FLAT, "c": FLAT, "f": FLAT, "bb": FLAT, "eb": FLAT}

var notes = [][]string{{"A"}, {"A#", "Bb"}, {"B"}, {"C"}, {"C#", "Db"}, {"D"}, {"D#", "Eb"}, {"E"}, {"F"}, {"F#", "Gb"}, {"G"}, {"G#", "Ab"}}

var intervalAddOn = map[byte]int{'M': 2, 'm': 1, 'A': 3}

func Scale(tonic string, interval string) []string {
	index := findNoteIndex(tonic)
	if interval == "" {
		interval = "mmmmmmmmmmmm"
	}
	typeOfScale := types[tonic]
	var scale []string
	for intervalIndex := range interval {
		scale = addNote(index, scale, typeOfScale)
		increment := intervalAddOn[interval[intervalIndex]]
		index = (index + increment) % len(notes)
	}
	return scale

}

func findNoteIndex(tonic string) int {
	index := -1
	for noteIndex := range notes {
		if noteMatch(tonic, noteIndex) {
			index = noteIndex
			break
		}
	}
	return index
}

func noteMatch(tonic string, index int) bool {
	if strings.Title(tonic) == notes[index][0] {
		return true
	}
	if len(notes[index]) == 2 && strings.Title(tonic) == notes[index][1] {
		return true
	}
	return false
}

func addNote(index int, scale []string, types int) []string {
	if len(notes[index]) == 2 {
		scale = append(scale, notes[index][types])
	} else {
		scale = append(scale, notes[index][0])
	}
	return scale
}
