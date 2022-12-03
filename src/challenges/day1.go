package main

import (
	"fmt"
	"math"
	"sort"
	"strconv"
)

func main() {
	// part 1
	fmt.Println(maxCalories())

	// part 2
	fmt.Println(topCalories(3))
}

func maxCalories() int {
	elfCalories := elfCalories()
	max := math.MinInt32

	for _, calories := range elfCalories {
		if calories > max {
			max = calories
		}
	}

	return max
}

func topCalories(limit int) int {
	elfCalories := elfCalories()
	sort.Slice(elfCalories, func(i, j int) bool {
		return elfCalories[i] > elfCalories[j]
	})

	topSum := 0
	for i := 0; i < limit; i++ {
		topSum += elfCalories[i]
	}

	return topSum
}

func elfCalories() []int {
	elfCalories := make([]int, 1)

	for _, line := range ReadFile("./resources/day1.txt") {
		if (line == "") {
			elfCalories = append(elfCalories, 0)
		} else {
			calories, _ := strconv.Atoi(line)
			elfCalories[len(elfCalories)-1] += calories
		}
	}

	return elfCalories
}