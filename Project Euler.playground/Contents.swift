//: # Project Euler
//:
//: ## 1. Multiples of 3 and 5
//:
//: If we list all the natural numbers below 10 that are multiples of 3 or 5, we get 3, 5, 6 and 9. The sum of these multiples is 23.
//:
//: Find the sum of all the multiples of 3 or 5 below 1000.
//:
func sumOfMultiplesOf3And5() -> Int {
    var sum = 0
    for n in 3..<1000 where n % 3 == 0 || n % 5 == 0 {
        sum += n
    }
    return sum
}
// there are floor(999 / 5) multiples of 5: 1 * 5 + 2 * 5 + 3 * 5 -> (1 + 2 + 3) * 5
// there are floor(999 / 3) multiples of 3: same

//sumOfMultiplesOf3And5()
//:
//: ## 2. Even Fibonacci numbers
//:
//: Each new term in the Fibonacci sequence is generated by adding the previous two terms. By starting with 1 and 2, the first 10 terms will be:
//:
//: 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...
//:
//: By considering the terms in the Fibonacci sequence whose values do not exceed four million, find the sum of the even-valued terms.
//:
func sumOfEvenFibonaccis(limit: Int = 4000000) -> Int {
    var sum = 2
    var n1 = 1
    var n2 = 2
    while n1 + n2 < limit {
        let temp = n1
        n1 = n2
        n2 = temp + n2
        if n2 % 2 == 0 {
            sum += n2
        }
    }
    print("Largest fib within limit is \(n2)")
    return sum
}

//sumOfEvenFibonaccis()
//:
//: ## 3. Largest prime factor
//:
//: The prime factors of 13195 are 5, 7, 13 and 29.
//:
//: What is the largest prime factor of the number 600851475143 ?
//:
//: > A prime number (or a prime) is a natural number greater than 1 that has no positive divisors other than 1 and itself. A natural number greater than 1 that is not a prime number is called a composite number.
//:
var primes = Set<Int>()

func isPrime(n: Int) -> Bool {
    if primes.contains(n) {
        return true
    }
    var isPrime = true
    var divisor = 2
    while divisor <= n / divisor {
        isPrime = n % divisor != 0
        if !isPrime { break }
        divisor++
    }
    if isPrime {
        primes.insert(n)
    }
    return isPrime
}

assert(isPrime(2))
assert(isPrime(3))
assert(!isPrime(4))

func findNextPrime(prime: Int) -> Int {
    var candidate = prime
    repeat {
        candidate++
    } while !isPrime(candidate)
    return candidate
}

assert(findNextPrime(29) == 31)

func largestPrimeFactor(n: Int) -> Int {
    // try dividing number, starting from smallest prime, 2
    // keep updating the bounds with each division until bounds <= divisor
    var prime = 1
    var factor = 1
    var safety = 1000
 
    while prime < n / prime && safety > 0 {
        safety--
        prime = findNextPrime(prime)
        if n % prime == 0 {
            factor = prime
        }
    }
    if safety == 0 {
        print("Too tired!")
    }

    return factor
}

// Wow.
//largestPrimeFactor(600851475143)
//:
//: ## 4. Largest palindrome product
//:
//: A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 × 99.
//:
//: Find the largest palindrome made from the product of two 3-digit numbers.
func isPalindrome(n: Int) -> Bool {
    let digits = Array(String(n).characters)
    if digits.count % 2 != 0 { return false }
    return digits.reverse() == digits
}

assert(isPalindrome(9009))
assert(!isPalindrome(123))

func largestPalindrome(digitsPerNumber: Int) -> Int {
    guard var n = Int(Array(count: digitsPerNumber, repeatedValue: "9").joinWithSeparator(""))
          else { return 0 }
    var n1: Int!
    var n2: Int!
    var product: Int!
    func reset() {
        n1 = n
        n2 = n
        product = n1 * n2
    }
    reset()
    while !isPalindrome(product) && product > 0 {
        if n1 > n2 { n1!-- }
        else { n2!-- }
        product = n1 * n2
    }
    var candidate = product
    reset()
    while !isPalindrome(product) && product > 0 {
        repeat {
            n2!--
            product = n1 * n2
            if product < candidate { break }
        } while !isPalindrome(product) && product > 0
        n2 = n
        n1!--
        product = n1 * n2
        if product < candidate { break }
    }
    if product > candidate {
        candidate = product
    }
    return candidate
}

largestPalindrome(3)