package main

import (
	"bufio"
	"fmt"
	"log"
	"math"
	"os"
	"strconv"
)

func main() {
	// part 1
	fmt.Printf("%d", maxCalories())
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

func elfCalories() []int {
	elfCalories := make([]int, 1)

	for _, line := range readFile() {
		if (line == "") {
			elfCalories = append(elfCalories, 0)
		} else {
			calories, _ := strconv.Atoi(line)
			elfCalories[len(elfCalories)-1] += calories
		}
	}

	return elfCalories
}

func readFile() []string {
	lines := make([]string, 0)

	file, readErr := os.Open("./resources/day1.txt")
	if readErr != nil {
		log.Fatal(readErr)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}

	return lines
}