package main

import (
	"bufio"
	"log"
	"os"
	"strconv"
)

func ReadFile(filepath string) []string {
	lines := make([]string, 0)

	file, readErr := os.Open(filepath)
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

func Atoi(s string) int {
	i, err := strconv.Atoi(s)
	if err != nil {
		log.Fatal(err)
	}
	return i
}