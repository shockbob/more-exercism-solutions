package bob

import "strings"
import "unicode"

func hasLetters(remark string) bool {
	for _,rem := range remark{
           if unicode.IsLetter(rem){
		return true;
           }
	}
	return false;
}
func Hey(remark string) string {
	remark = strings.TrimFunc(remark,unicode.IsSpace)
	if remark == ""{
		return "Fine. Be that way!"
	}
	if ! hasLetters(remark) {
	   if strings.HasSuffix(remark,"?"){
               return  "Sure."
           }
	   return "Whatever."
	}
	if remark == strings.ToUpper(remark) && strings.HasSuffix(remark,"?"){
           return "Calm down, I know what I'm doing!"
	}
	if remark == strings.ToUpper(remark) { 
           return "Whoa, chill out!"
	}
	if strings.HasSuffix(remark,"?"){
           return "Sure."
	}
	return "Whatever."
}
