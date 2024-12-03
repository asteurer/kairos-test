package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strings"
)

func main() {
	output := make(map[string]int)
	file, err := os.Open("../output.log")
	check(err)
	defer file.Close()

	var currentEntry strings.Builder
	logStartRegex := regexp.MustCompile(`^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\s+(INF|WRN|ERR|DEBUG|TRACE)`)

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Text()
		if logStartRegex.MatchString(line) {
			if currentEntry.Len() > 0 {
				output[currentEntry.String()[24:]]++
				currentEntry.Reset()
			}
		}

		currentEntry.WriteString(line + "\n")
	}

	if currentEntry.Len() > 0 {
		output[currentEntry.String()[24:]]++
	}

	check(scanner.Err())

	for key, value := range output {
		fmt.Printf("%s: %d\n#############################\n", key, value)
	}

}

func check(err error) {
	if err != nil {
		panic(err)
	}
}
