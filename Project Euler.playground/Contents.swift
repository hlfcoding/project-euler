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

extension Int {
    func isPrime() -> Bool {
        if primes.contains(self) {
            return true
        }
        var isPrime = true
        var divisor = 2
        while divisor <= self / divisor {
            isPrime = self % divisor != 0
            if !isPrime { break }
            divisor++
        }
        if isPrime {
            primes.insert(self)
        }
        return isPrime
    }

    func nextPrime() -> Int {
        var candidate = self
        repeat {
            candidate++
        } while !candidate.isPrime()
        return candidate
    }
}

assert(2.isPrime())
assert(3.isPrime())
assert(!4.isPrime())

assert(29.nextPrime() == 31)

extension Int {
    /**
     Try dividing number, starting from smallest prime, 2.
     Keep updating the bounds with each division until bounds <= divisor.
     */
    func largestPrimeFactor() -> Int {
        var prime = 1
        var factor = 1
        var safety = 1000

        while prime < self / prime && safety > 0 {
            safety--
            prime = prime.nextPrime()
            if self % prime == 0 {
                factor = prime
            }
        }
        if safety == 0 {
            print("Being safe and not continuing!")
        }
        
        return factor
    }
}

// Wow.
//600851475143.largestPrimeFactor()
//:
//: ## 4. Largest palindrome product
//:
//: A palindromic number reads the same both ways. The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 × 99.
//:
//: Find the largest palindrome made from the product of two 3-digit numbers.
//:
//: ---
//:
//: First solution decreases both factors simultaneously. This approach is faster at finding a palindrome but unlikely to find the largest palindrome.
//:
//: Second solution quadratically checks by running through first n largest possiblities of second factor against each n largest possibilities of first factor.
//:

extension Int {
    func isPalindrome() -> Bool {
        let digits = Array(String(self).characters)
        if digits.count % 2 != 0 { return false }
        return digits.reverse() == digits
    }
}

assert(9009.isPalindrome())
assert(!123.isPalindrome())

func largestPalindromeFromTwoNumbersWithDigits(digits: Int) -> Int {
    guard let n = Int(Array(count: digits, repeatedValue: "9").joinWithSeparator(""))
          else { return 0 }
    var n1 = n
    var n2 = n
    var product = n1 * n2
//    while !isPalindrome(product) && product > 0 {
//        if n1 > n2 { n1-- }
//        else { n2-- }
//        product = n1 * n2
//    }
    repeat {
        n2 = n
        repeat {
            product = n1 * n2
            n2--
        } while !product.isPalindrome() && Double(n2) / Double(n) > 0.9
        n1--
    } while !product.isPalindrome() && Double(n1) / Double(n) > 0.9
    return product
}

//largestPalindromeFromTwoNumbersWithDigits(3)