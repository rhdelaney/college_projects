; HELPER FUNCTIONS FOR COMPARISON OF BIG-INTS
(define old+ +)
(define old* *)
(define old- -)
(define old/ /)
(define (pop stack)
    (if (null? stack)
        nil
        (cdr stack)
    )
)
(define (+ x y)
    (define end (big+ (int-to-big x) (int-to-big y)) )
    (if (or (>= (big-to-int end) 32767) (<= (big-to-int end) -32768))
        end
        (big-to-int end)
    )
)
(define (- x y)
    (define end (big- (int-to-big x) (int-to-big y)) )
    (if (or (>= (big-to-int end) 32767) (<= (big-to-int end) -32768))
        end
        (big-to-int end)
    )
)
(define (* x y)
    (define end (big* (int-to-big x) (int-to-big y)))

    (if (or (>= (big-to-int end) 32767) (<= (big-to-int end) -32768))
        end
        (big-to-int end)
    )
)
(define (/ x y)
    (define end (big/ (int-to-big x) (int-to-big y)))
    (if (or (>= (big-to-int end) 32767) (<= (big-to-int end) -32768))
        end
        (big-to-int end)
    )
)
(define (big-to-int big)
    (define (recur big pow)
        (if (null? big)
            0
            (old+ (old* (car big) (expt 10 pow)) (recur (cdr big) (old+ pow 1)))
        )
    )
    (if (isNeg? big)
        (old* -1 (recur (reverse (cdr big)) 0))
        (recur (reverse big) 0)
    )
)
(define (int-to-big int)
    (define (recur int)
        (if (= int 0)
            nil
            (cons (remainder int 10) (recur (old/ int 10)))
        )
    )
  ; This check allows for big ints to be passed in as well
    (if (integer? int)
        (cond
            ((= int 0) '(0))
            ((> int 0) (reverse (recur int)))
            (else (cons '- (reverse (recur (abs int)))))
        )
        (if (null? int)
            '(0)
            int
        )
    )
)
; DETERMINES IF OPERAND IS NEGATIVE
(define (isNeg? operand)
    (if (null? operand)
        (isNeg? '(0))
        (equal? (car operand) '-)
    )
)
; DETERMINES IF OPERAND1 = OPERAND2
(define (big= operand1 operand2)
    (if (null? operand1)
        (big= '(0) operand2)
        (if (null? operand2)
            (big= operand1 '(0))
            (equal? operand1 operand2)
        )
    )
)
; DETERMINES IF OPERAND1 > OPERAND2
(define (big> operand1 operand2)
    (if (null? operand1)
        (big> '(0) operand2)
        (if (null? operand2)
            (big> operand1 '(0))
            (if (isNeg? operand1)
                (if (isNeg? operand2)
                    (big< (cdr operand1) (cdr operand2))
                    #f
                )
                (if (isNeg? operand2)
                    #t
                    (and (not (big= operand1 operand2))
                    (or (> (length operand1) (length operand2))
                    (and (= (length operand1) (length operand2))
                    (or (> (value operand1) (value operand2))
                    (and (= (value operand1) (value operand2))
                    (big> (pop operand1) (pop operand2))))))
                    )
                )
            )
        )
    )
)
; DETERMINES IF OPERAND1 < OPERAND2
(define (big< operand1 operand2)
    (if (null? operand1)
        (big< '(0) operand2)
        (if (null? operand2)
            (big< operand1 '(0))
            (if (isNeg? operand1)
                (if (isNeg? operand2)
                    (big> (cdr operand1) (cdr operand2))
                    #t
                )
                (if (isNeg? operand2)
                    #f
                    (not (or (big> operand1 operand2)
                    (big= operand1 operand2)))
                )
            )
        )
    )
)
; return the value of the operand
(define (value operand)
    (if (null? operand)
        0
        (car operand)
    )
)
; trims the 0's of the front
(define (trim-0 bigInt)
    (if (null? bigInt)
        '(0)
        (if (equal? (car bigInt) 0)
            (trim-0 (cdr bigInt))
            bigInt
        )
    )
)
(define (big+ augend addend)
    (define (add augend addend overflow)
        (if (and (null? augend) (null? addend))
            (if (= overflow 0) nil '(1))
            (begin
                (define sum (old+ (value augend) (value addend) overflow))
                (append (list (remainder sum 10)) (add (pop augend) (pop addend) (if (> sum 9) 1 0))
                )
            )
        )
    )
  ; tests if the addition can be simplified into positive numbers
    (cond
        ((and (null? augend) (null? addend)) '(0))
        ((null? augend) addend)
        ((null? addend) augend)
        ((isNeg? augend) (big- addend (big-abs augend)))
        ((isNeg? addend) (big- augend (big-abs addend)))
        (else (trim-0 (reverse (add (reverse augend) (reverse addend) 0))))
    )
)
; subtraction ultimately by addition
(define (big- minuend subtrahend)
  ; return the 10's complement of bigInt
    (define (complement bigInt)
    ; recur returns the 9's complement of bigInt
        (define (recur bigInt)
            (if (null? bigInt)
                nil
                (cons (old- 9 (car bigInt)) (recur (cdr bigInt)))
            )
        )
        (big+ (reverse (recur (reverse bigInt))) '(1))
    )

    (define (add-zero bigInt n)
        (if (= n 0)
            bigInt
            (cons 0 (add-zero bigInt (old- n 1)))
        )
    )
    (define length-diff
        (old- (length minuend) (length subtrahend))
    )
    (cond
        ((and (null? minuend) (null? subtrahend)) '(0))
        ((null? minuend) (big- '(0) subtrahend))
        ((null? subtrahend) minuend)
        ((isNeg? minuend) (begin (define result (big+ (big-abs minuend) subtrahend)) 
            (if (isNeg? result) 
                result 
                (cons '- result)
            )
        ))
        ((isNeg? subtrahend) (big+ minuend (big-abs subtrahend)))
        ((big< minuend subtrahend) (cons '- (big- subtrahend minuend)))
        (else (trim-0 (pop (big+ minuend ;subtract by adding the complement
            (complement 
                (if (> length-diff 0)
                    (add-zero subtrahend length-diff)
                    subtrahend
                )
            ))))
        )
    )
)
; (define (big* multiplicand multiplier)
;     (define (upper bigInt n)
;         (define (recur bigInt)
;             (if (null? bigInt)
;                 nil
;                 (if (= (length bigInt) n)
;                     nil
;                     (cons (car bigInt) (recur (cdr bigInt)))
;                 )
;             )
;         )
;         (recur bigInt)
;     )
;     (define (lower bigInt n)
;         (if (null? bigInt)
;             '(0)
;             (if (= (length bigInt) n)
;                 bigInt
;                 (lower (cdr bigInt) n)
;             )
;         )
;     )
;     (define (big-*-int multiplicand multiplier)
;         (define (recur multiplicand overflow)
;             (if (null? multiplicand)
;                 (reverse (int-to-big overflow))
;                 (begin
;                     (define product (old* (car multiplicand) multiplier))
;                     (cons (old+ (remainder product 10) overflow) (recur (cdr multiplicand) (old/ product 10)))
;                 )
;             )
;         )
;         (reverse (recur (reverse multiplicand) 0))
;     )
;   ; mult chooses which one is small enough to become a int 0-9
;     (define (mult multiplicand multiplier)
;         (if (big< multiplicand '(1 0))
;             (big-*-int multiplier (big-to-int multiplicand))
;             (big-*-int multiplicand (big-to-int multiplier))
;         )
;     )
;     (define (isSmall? a b)
;         (or (big< a '(1 0)) (big< b '(1 0)))
;     )
;     (define (karatsuba multiplicand multiplier)
;         (if (isSmall? multiplicand multiplier)
;             (trim-0 (mult multiplicand multiplier))
;             (begin
;                 (define m ((lambda (x y) (if (< x y) y x)) (length multiplicand) (length multiplier)))
;                 (define m2 (old/ m 2))
;                 (define high1 (upper multiplicand m2))
;                 (define high2 (upper multiplier m2))
;                 (define low1 (lower multiplicand m2))
;                 (define low2 (lower multiplier m2))
;                 (define z0 (karatsuba low1 low2))
;                 (define z1 (karatsuba (big+ low1 high1) (big+ low2 high2)))
;                 (define z2 (karatsuba high1 high2))
;                 (big+ (big+ (shift-right z2 (old* 2 m2)) (shift-right (big- (big- z1 z2) z0) m2)) z0)
;             )
;         )
;     )
;   ; shift bigInt right by number, fill with 0's
;     (define (shift-right bigInt number)
;         (define (iter bigInt count)
;             (if (= count number)
;                 bigInt
;                 (iter (append bigInt '(0)) (old+ count 1))
;             )
;         )
;         (iter bigInt 0)
;     )
;   ; only multiply positive numbers, make negative
;     (if (or (null? multiplicand) (null? multiplier))
;         '(0)
;         (begin
;             (define ans (karatsuba (big-abs multiplicand) (big-abs multiplier)))
;             (if (xor (isNeg? multiplicand) (isNeg? multiplier))
;                 (cons '- (trim-0 ans))
;                 (trim-0 ans)
;             )
;         )
;     )
; )
(define (big* multiplicand multiplier)
    (define (karatsuba mcand plier count total)
      (if(big= count plier)
        total
        (karatsuba mcand plier (big+ count '(1)) (big+ total mcand) )
      )
    )
    (if (or (null? multiplicand) (null? multiplier) (big= multiplier '(0) ) (big= multiplicand '(0) ))
        '(0)
        (begin
            (if (big> (big-abs multiplicand) (big-abs multiplier) )
                (define ans (karatsuba (big-abs multiplicand) (big-abs multiplier) '(1) (big-abs multiplicand)))
                (define ans (karatsuba (big-abs multiplier) (big-abs multiplicand) '(1) (big-abs multiplier)))
            )
            ;(define ans (karatsuba (big-abs multiplicand) (big-abs multiplier) '(0) (big-abs multiplicand)))
            (if (xor (isNeg? multiplicand) (isNeg? multiplier))
                (cons '- (trim-0 ans))
                (trim-0 ans)
            )
        )
    )
)
;division by subtraction?
; (define (big/ dividend divisor)
;     (define (upper bigInt n)
;         (define (recur bigInt)
;             (if (null? bigInt)
;                 nil
;                 (if (= (length bigInt) n)
;                     nil
;                     (cons (car bigInt) (recur (cdr bigInt)))
;                 )
;             )
;         )
;         (recur bigInt)
;     )
;     (define (lower bigInt n)
;         (if (null? bigInt)
;             '(0)
;             (if (= (length bigInt) n)
;                 bigInt
;                 (lower (cdr bigInt) n)
;             )
;         )
;     )
;     (define (big-*-int dividend divisor)
;         (define (recur dividend overflow)
;             (if (null? dividend)
;                 (reverse (int-to-big overflow))
;                 (begin
;                     (define product (old* (car dividend) divisor))
;                     (cons (old+ (remainder product 10) overflow) (recur (cdr dividend) (old/ product 10)))
;                 )
;             )
;         )
;         (reverse (recur (reverse dividend) 0))
;     )
;   ; mult chooses which one is small enough to become a int 0-9
;     (define (mult dividend divisor)
;         (if (big< dividend '(1 0))
;             (big-*-int divisor (big-to-int dividend))
;             (big-*-int dividend (big-to-int divisor))
;         )
;     )
;     (define (isSmall? a b)
;         (or (big< a '(1 0)) (big< b '(1 0)))
;     )
;     (define (burnzieg dividend divisor)
;         (if (isSmall? dividend divisor)
;             (trim-0 (mult dividend divisor))
;             (begin
;                 (define m ((lambda (x y) (if (< x y) y x)) (length dividend) (length divisor)))
;                 (define m2 (old/ m 2))
;                 (define high1 (upper dividend m2))
;                 (define high2 (upper divisor m2))
;                 (define low1 (lower dividend m2))
;                 (define low2 (lower divisor m2))
;                 (define z0 (burnzieg low1 low2))
;                 (define z1 (burnzieg (big+ low1 high1) (big+ low2 high2)))
;                 (define z2 (burnzieg high1 high2))
;                 (big+ (big+ (shift-right z2 (old* 2 m2)) (shift-right (big- (big- z1 z2) z0) m2)) z0)
;             )
;         )
;     )
;   ; shift bigInt right by number, fill with 0's
;     (define (shift-right bigInt number)
;         (define (iter bigInt count)
;             (if (= count number)
;                 bigInt
;                 (iter (append bigInt '(0)) (old+ count 1))
;             )
;         )
;         (iter bigInt 0)
;     )
;   ; only multiply positive numbers, make negative
;     (if (or (null? dividend) (null? divisor) (big< dividend divisor) )
;         '(0)
;         (begin
;             (define ans (burnzieg (big-abs dividend) (big-abs divisor)))
;             (if (xor (isNeg? dividend) (isNeg? divisor))
;                 (cons '- (trim-0 ans))
;                 (trim-0 ans)
;             )
;         )
;     )
; )
(define (big/ dividend divisor)
    (define (burnzieg dividend divisor count)
        (cond
            ((big= (big- dividend divisor) '(0)) (big+ count '(1)))
            ((big> (big- dividend divisor) '(0))
                (burnzieg (big- dividend divisor) divisor (big+ count '(1))) 
            )
            (else  count )
        )
    )
    (if (or (null? dividend) (null? divisor) (big< (big-abs dividend) (big-abs divisor) ))
        '(0)
        (begin
            (define ans (burnzieg (big-abs dividend) (big-abs divisor) '(0) ))
            (if (xor (isNeg? dividend) (isNeg? divisor))
                (cons '- (trim-0 ans))
                (trim-0 ans)
            )
        )
    )
)
;before this needs fixing
; removes redundancy, positive number always returned
(define (big-abs bigInt)
    (if (isNeg? bigInt)
        (cdr bigInt)
        bigInt
    )
)
; XOR defined
(define (xor x y)
    (and (or x y) (not (and x y) ) )
)
(define (main)
  (setPort (open (getElement ScamArgs 1) 'read))
    (define f (readExpr))
    (define first (readExpr))
    (println (+ f first))
    (println (- f first) )
    (println (* f first) )
    (println (/ f first) )
)