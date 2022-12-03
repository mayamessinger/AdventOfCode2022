package main

import (
	"fmt"
	"log"
	"strings"
)

func main() {
	// part 1
	fmt.Println(duplicateItemPrioritySum())
}

func duplicateItemPrioritySum() int {
	sum := 0

	for _, line := range ReadFile("./resources/day3.txt") {
		sum += rucksackItemPriority(line)
	}

	return sum
}

func rucksackItemPriority(line string) int {
	compartment1 := line[0:len(line)/2+1]
	compartment2 := line[len(line)/2:len(line)]
	duplicateItem := findDuplicateItem(compartment1, compartment2)

	return itemScore(duplicateItem)
}

func findDuplicateItem(compartment1 string, compartment2 string) rune {
	for _, item := range compartment1 {
		if strings.Contains(compartment2, string(item)) {
			return rune(item)
		}
	}

	log.Fatal("No duplicate item found")
	return rune(0)
}

func itemScore(item rune) int {
	if (item >= rune('A')) && (item <= rune('Z')) {
		return int(item) - 38 // int values of runes A-Z are 65-90, but priority values are 27-52 so 38 offset
	}
	if (item >= rune('a')) && (item <= rune('z')) {
		return int(item) - 96 // int values of runes a-z are 97-122, but priority values are 1-26 so 96 offset
	}

	log.Fatal("Invalid item")
	return -1
}