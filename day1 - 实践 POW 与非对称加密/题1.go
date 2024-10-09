package main

import (
	"crypto/sha256"
	"encoding/hex"
	"strconv"
	"strings"
	"time"
)

// 实践 POW

func isValidHashWith(hash string, n int) bool {
	return strings.HasPrefix(hash, strings.Repeat("0", n))
}

func proofOfWork(data string, zeros int) (time.Duration, string, string) {
	startTime := time.Now()
	nonce := 0
	for {
		input := data + strconv.Itoa(nonce)
		hash := sha256.Sum256([]byte(input))
		hashString := hex.EncodeToString(hash[:])
		if isValidHashWith(hashString, zeros) {
			return time.Since(startTime), input, hashString //花费的时间、Hash 的内容及Hash值
		}
		nonce++
	}
}
