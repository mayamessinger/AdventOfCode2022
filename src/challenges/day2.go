package main

import (
	"fmt"
	"log"
	"strings"
)

func main() {
	// part 1
	fmt.Println(score())
}

func score() int {
	score := 0

	for _, line := range ReadFile("./resources/day2.txt") {
		score += lineScore(line)
	}

	return score
}

func lineScore(line string) int {
	letter, elfLetter := parseLine(line)
	shape := shapeFromLetter(letter)
	elfShape := shapeFromLetter(elfLetter)

	points, _ := pointsForRound(shape, elfShape)

	return points + pointsForShape(shape)
}

func parseLine(line string) (rune, rune) {
	splitLine := strings.Split(line, " ")
	return []rune(splitLine[1])[0], []rune(splitLine[0])[0]
}

func shapeFromLetter(letter rune) string {
	switch letter {
	case rune('A'):
		fallthrough
	case rune('X'):
		return "rock"
	case rune('B'):
		fallthrough
	case rune('Y'):
		return "paper"
	case rune('C'):
		fallthrough
	case rune('Z'):
		return "scissors"
	}

	log.Fatal("Invalid letter")
	return ""
}

func pointsForShape(shape string) int {
	switch shape {
	case "rock":
		return 1
	case "paper":
		return 2
	case "scissors":
		return 3
	}

	log.Fatal("Invalid shape")
	return -1
}

func pointsForRound(shape string, opponentShape string) (int, int) {
	switch shape {
	case "rock":
		switch opponentShape {
		case "rock":
			return 3, 3
		case "paper":
			return 0, 6
		case "scissors":
			return 6, 0
		}
	case "paper":
		switch opponentShape {
		case "rock":
			return 6, 0
		case "paper":
			return 3, 3
		case "scissors":
			return 0, 6
		}
	case "scissors":
		switch opponentShape {
		case "rock":
			return 0, 6
		case "paper":
			return 6, 0
		case "scissors":
			return 3, 3
		}
	}

	log.Fatal("Invalid shape combination")
	return -1, -1
}