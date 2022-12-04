package main

import (
	"fmt"
	"strings"
	"strconv"
)

func main() {
	// part 2
	fmt.Println(overlappingRangeSum())
}

func overlappingRangeSum() int {
	sum := 0

	for _, line := range ReadFile("./resources/day4.txt") {
		range1, range2 := parseRanges(line)
		if rangesOverlap(range1, range2) {
			sum += 1
		}
	}

	return sum
}

func parseRanges(line string) ([]int, []int) {
	rangeStrings := strings.Split(line, ",")
	range1 := strings.Split(rangeStrings[0], "-")
	range1Start, _ := strconv.Atoi(range1[0])
	range1End, _ := strconv.Atoi(range1[1])
	range2 := strings.Split(rangeStrings[1], "-")
	range2Start, _ := strconv.Atoi(range2[0])
	range2End, _ := strconv.Atoi(range2[1])

	return []int{range1Start, range1End}, []int{range2Start, range2End}
}

func isFullyContainedRange(range1 []int, range2 []int) bool {
	if (range1[0] >= range2[0] && range1[1] <= range2[1]) ||
		(range2[0] >= range1[0] && range2[1] <= range1[1]) {
		return true
	}

	return false
}

func rangesOverlap(range1 []int, range2 []int) bool {
	if (range1[0] <= range2[0] && range1[1] >= range2[0]) ||
		(range2[0] <= range1[0] && range2[1] >= range1[0]) {
		return true
	}

	return false
}