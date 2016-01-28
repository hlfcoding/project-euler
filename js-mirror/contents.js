/*jshint node: true */

'use strict';

// ## 1. Multiples of 3 and 5
//
// If we list all the natural numbers below 10 that are multiples of 3 or 5,
// we get 3, 5, 6 and 9. The sum of these multiples is 23.
//
// Find the sum of all the multiples of 3 or 5 below 1000.

function triangleNumber(n) {
  return n * (n + 1) / 2;
}

function sumOfMultiplesOf3And5Below(limit) {
  // Approach 2: O(1): use triangle number formula: f(3) = 1 + 2 + 3
  let inclusiveLimit = limit - 1;
  let sum3 = 3 * triangleNumber(inclusiveLimit / 3);
  let sum5 = 5 * triangleNumber(inclusiveLimit / 5);
  let product = 3 * 5;
  let intersection = product * triangleNumber(inclusiveLimit / product);
  return parseInt(sum3 + sum5 - intersection);
}

console.assert(sumOfMultiplesOf3And5Below(10) == (3 + 5 + 6 + 9), 'sumOfMultiplesOf3And5Below');
//console.log(sumOfMultiplesOf3And5Below(1000));

// ## 2. Even Fibonacci numbers
//
// Each new term in the Fibonacci sequence is generated by adding the previous
// two terms. By starting with 1 and 2, the first 10 terms will be:
//
// 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...
//
// By considering the terms in the Fibonacci sequence whose values do not exceed
// four million, find the sum of the even-valued terms.

function sumOfEvenFibonaccis(limit, debug = false) {
  let sum = 2;
  let n1 = 1;
  let n2 = 2;
  while (n1 + n2 < limit) {
    let next = n1 + n2;
    n1 = n2;
    n2 = next;
    if (n2 % 2 === 0) {
      sum += n2;
    }
  }
  if (debug) {
    console.log(`Largest fib within limit is ${n2}`);
  }
  return sum;
}

console.assert(sumOfEvenFibonaccis(34) === 10, 'sumOfEvenFibonaccis');
//console.log(sumOfEvenFibonaccis(4000000));

// ## 3. Largest prime factor
//
// The prime factors of 13195 are 5, 7, 13 and 29.
//
// What is the largest prime factor of the number 600851475143?
//
// > A prime number (or a prime) is a natural number greater than 1 that has no
//   positive divisors other than 1 and itself. A natural number greater than 1
//   that is not a prime number is called a composite number.

let primes = new Set();

function isPrime(n) {
  if (primes.has(n)) {
    return true;
  }
  let is = true;
  let divisor = 2;
  while (divisor <= (n / divisor)) {
    is = n % divisor !== 0;
    if (!is) { break; }
    divisor++;
  }
  if (is) {
    primes.add(n);
  }
  return is;
}

console.assert(isPrime(2), 'isPrime');
console.assert(isPrime(3), 'isPrime');
console.assert(!isPrime(4), 'isPrime');

function nextPrime(n) {
  let candidate = n;
  do {
    candidate++;
  } while (!isPrime(candidate));
  return candidate;
}

console.assert(nextPrime(29) === 31);

function largestPrimeFactor(n) {
  let prime = 1;
  let factor = 1;
  let safety = 1000;
  while (prime < (n / prime) && safety > 0) {
    safety--;
    if (safety === 0) {
      console.log('Being safe and not continuing!');
    }
    prime = nextPrime(prime);
    if (n % prime === 0) {
      factor = prime;
    }
  }
  return factor;
}

//console.log(largestPrimeFactor(600851475143));

// ## 4. Largest palindrome product
//
// A palindromic number reads the same both ways. The largest palindrome made
// from the product of two 2-digit numbers is 9009 = 91 × 99.
//
// Find the largest palindrome made from the product of two 3-digit numbers.
//
// ---
//
// Solution quadratically checks by running through first n largest possiblities
// of second factor against each n largest possibilities of first factor. Since
// the number of digits is small, we don't need to be most efficient.

function reverse(s) {
  return s.split('').reverse().join('');
}

console.assert(reverse('foo') === 'oof', 'reverse');

function isPalindrome(n) {
  let digits = (n).toString();
  if (digits.length % 2 !== 0) { return false; }
  return reverse(digits) === digits;
}

console.assert(isPalindrome(9009), 'isPalindrome');
console.assert(!isPalindrome(123), 'isPalindrome');

function largestPalindromeFromTwoNumbersWithDigits(digits) {
  let n = parseInt('9'.repeat(digits));
  let n1 = n;
  let n2 = n;
  let product = n1 * n2;
  do {
    n2 = n;
    do {
      product = n1 * n2;
      n2--;
    } while (!isPalindrome(product) && (n2 / n) > 0.9);
    n1--;
  } while (!isPalindrome(product) && (n1 / n) > 0.9);
  return product;
}

console.assert(largestPalindromeFromTwoNumbersWithDigits(2) === 9009, 'largestPalindromeFromTwoNumbersWithDigits');
//console.log(largestPalindromeFromTwoNumbersWithDigits(3));

// ## 5. Smallest multiple
//
// 2520 is the smallest number that can be divided by each of the numbers from 1
// to 10 without any remainder.
//
// What is the smallest positive number that is evenly divisible by all of the
// numbers from 1 to 20?
//
// ---
//
// The initial approach is to just have the step be the max factor. This won't
// scale for the larger range. Instead, the product of the primes in the range
// seems like a much better step, for reasons yet fully clear. Another
// optimization is to remove redundancies in the factors before checking
// divisibility.

function isDivisibleBy(n, divisors) {
  let nonDivisor = divisors.find(d => n % d !== 0);
  return nonDivisor === undefined;
}

console.assert(isDivisibleBy(4, [1, 2]), 'isDivisibleBy');

function createRange(length, start = 0) {
  return Array.from(new Array(length), (_, i) => i + start);
}

console.assert(createRange(3, 1).toString() === [1, 2, 3].toString(), 'createRange');

function smallestMultipleDivisibleByRange(range, debug = false) {
  let factors = [];
  let step = 1;
  range.reverse().forEach((n) => {
    if (isPrime(n)) {
      step *= n;
    }
    for (let i = 0, l = factors.length; i < l; i++) {
      let f = factors[i];
      if (f > n && f % n === 0) {
        return;
      }
    }
    factors.push(n);
  });
  if (debug) {
    console.log(`Step: ${step}, factors: ${factors}`);
  }
  let multiple = 0;
  do {
    multiple += step;
  } while (!isDivisibleBy(multiple, factors));
  return multiple;
}

console.assert(smallestMultipleDivisibleByRange(createRange(10, 1)) === 2520, 'smallestMultipleDivisibleByRange');
//console.log(smallestMultipleDivisibleByRange(createRange(20, 1)));
