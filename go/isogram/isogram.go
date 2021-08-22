package isogram
import "strings"

func IsIsogram(which string) bool {
	which = strings.ReplaceAll(which,"-","")
	which = strings.ReplaceAll(which," ","")
	which = strings.ToLower(which)
	if  len(which) == 0{
	    return true;
	}
	mapstr := make(map[rune]bool)
	for _,str := range which {
           exists := mapstr[str]
	   if exists {
	      return false;
	   }
	   mapstr[str] = true
	}
	return true;
}
