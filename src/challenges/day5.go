package main

import (
	"fmt"
	"regexp"
	"strings"
)

type Movement struct {
	from int
	to int
	count int
}

func main() {
	// part 1
	fmt.Println(topCrates(false))

	// part 2
	fmt.Println(topCrates(true))
}

func topCrates(keepMultipleOrder bool) string {
	crateStacks, moves := parseLines()	
	crateStacks = reverseCratesStackFromQueue(crateStacks) // input is in queue format, want stack format
	crateStacks = processMoves(crateStacks, moves, keepMultipleOrder)

	return getTopCrates(crateStacks)
}

func parseLines() ([][]rune, []Movement) {
	crateStacks := [][]rune{}
	moves := []Movement{}

	for _, line := range ReadFile("./resources/day5.txt") {
		if (strings.Contains(line, "[")) {
			crateStacks = addCratesToStacks(line, crateStacks)
		}

		if (strings.Contains(line, "move")) {
			moves = append(moves, parseMovement(line))
		}
	}

	return crateStacks, moves
}

func addCratesToStacks(line string, crateStacks [][]rune) [][]rune {
	replacer := strings.NewReplacer("    ", ".", " ", "", "[", "", "]", "")
	line = replacer.Replace(line)

	for crate, contents := range []rune(line) {
		if (len(crateStacks) <= crate) {
			crateStacks = append(crateStacks, []rune{})
		}
		if (contents != '.') {
			crateStacks[crate] = append(crateStacks[crate], contents)
		}
	}

	return crateStacks
}

func parseMovement(instruction string) Movement {
	format := regexp.MustCompile(`move (?P<count>\d{1,}) from (?P<from>\d{1,}) to (?P<to>\d{1,})`)
	matches := format.FindStringSubmatch(instruction)

	return Movement { from: Atoi(matches[2]), to: Atoi(matches[3]), count: Atoi(matches[1]) }
}

func reverseCratesStackFromQueue(crateStacks [][]rune) [][]rune {
	for _, stack := range crateStacks {
		for i, j := 0, len(stack) - 1; i < j; i, j = i + 1, j - 1 {
			stack[i], stack[j] = stack[j], stack[i]
		}
	}

	return crateStacks
}

func processMoves(crateStacks [][]rune, moves []Movement, keepMultipleOrder bool) [][]rune {
	for _, move := range moves {
		if (keepMultipleOrder) {
			items, fromStack := popMultiple(crateStacks[move.from - 1], move.count)
			crateStacks[move.from - 1] = fromStack
			crateStacks[move.to - 1] = pushMultiple(crateStacks[move.to - 1], items)
		} else {
			for i := 0; i < move.count; i++ {
				item, fromStack := pop(crateStacks[move.from - 1])
				crateStacks[move.from - 1] = fromStack
				crateStacks[move.to - 1] = push(crateStacks[move.to - 1], item)
			}
		}
	}

	return crateStacks
}

func getTopCrates(crateStacks [][]rune) string {
	topCrates := ""

	for _, stack := range crateStacks {
		topCrates += string(stack[len(stack) - 1])
	}

	return topCrates
}

func push(stack []rune, item rune) []rune {
	stack = append(stack, item)
	
	return stack
}

func pushMultiple(stack[] rune, items []rune) []rune {
	for _, item := range items {
		stack = push(stack, item)
	}

	return stack
}

func pop(stack []rune) (rune, []rune) {
	item := peek(stack)
	stack = (stack)[:len(stack) - 1]

	return item, stack
}

func popMultiple(stack []rune, count int) ([]rune, []rune) {
	items := stack[len(stack) - count:len(stack)]
	stack = (stack)[:len(stack) - count]

	return items, stack
}

func peek(stack []rune) rune {
	return stack[len(stack) - 1]
}