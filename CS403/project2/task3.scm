; (define (main)
;   (setPort (open (getElement ScamArgs 1) 'read))
;   (define f (readExpr))
;   (println (infix->postfix f))
;   ;(println (infix->postfix (quote (-299 / a - q / z ^ 212 ^ k / v ^ 582 - v ^ x / a + u + j / -424 / 65 - 30 / m * p - -137 + -414 + f + s ^ 106 - z * i + n / j + -626 / j + l * h / f - g ^ -905 ^ o - k / 937 + -775 - 231 / -402 + c - -980 / w ^ z ^ 369 * m ^ 779 ^ -221 ^ p * 821 ^ 314 ^ a))) )
;   ;(println (infix->postfix '(2 + 3 * x ^ 5 + a)))
;   ;Basically it thinks 'a' is a symbol/operation which I guess technically it kinda is in scheme
;   ; so basically add a proper conditional check -> (if (operation in) else( treat like integer)) 
;   ;(-299 a / q z 212 ^ k ^ / v 582 ^ / - v x ^ a / - u + j -424 / 65 / 30 m / p * - -137 - + -414 + f + s 106 ^ z i * - + n j / + -626 j / + l h f / * g -905 ^ o ^ - k 937 / - + -775 231 -402 / - + c -980 w z ^ 369 ^ / m 779 ^ -221 ^ p ^ * 821 314 ^ a ^ * - +)
; )
; (define (flatten x)
;   (cond 
;     ((null? x) '())
;     ((pair? x) (append (flatten (car x)) (flatten (cdr x))))
;     (else (list x))
;   )
; )
; (define (push item stack)
;   ;(println "push= " stack)
;   (cons item stack)
; )

; (define (peek stack)
;   ;(println "peek= " stack)
;   (if (null? stack)
;     nil
;     (car stack)
;   )
; )

; (define (pop stack)
;   ;(println "pop= " stack)
;   (if (null? stack)
;     nil
;     (cdr stack)
;   )
; )

; (define (infix->postfix lyst)
;   (define (op-precedence sym)
;     (if (or (equal? sym '+) (equal? sym '-))
;       1
;       (if (or (equal? sym '*) (equal? sym '/))
;         2
;         (if (equal? sym '^)
;           3
;           0
;         )
;       )
;     )
;   )
;   (define (apply-op op stack)
;     ;(println "app-op= " op " : " stack)
;     (push (list (peek stack) (peek (pop stack)) op) (pop (pop stack)))
;     ;(push (list op (peek stack) (peek (pop stack))) (pop (pop stack)))
;   )
; (define (get-postfix expression opstack postfix)
;    ; (println opstack " : ")
;     (if (null? expression)
;       (if (null? opstack)
;         (peek postfix)
;         (get-postfix expression (pop opstack) (apply-op (peek opstack) postfix)) 
;       )
;       (begin (define sym-precedence (op-precedence (peek expression)))
;         ;(println "op: "sym-precedence " peek: " (peek expression))
;         (if (> sym-precedence 0)
;           (if (< sym-precedence (op-precedence (peek opstack)))
;             ;(if (= sym-precedence 3)
;               ;push here
;               ;OG=>(get-postfix (pop expression) (push (peek expression) (pop opstack)) (apply-op (peek opstack) postfix))
              
;             ;  (get-postfix (pop expression) (push (peek expression) (pop opstack)) (apply-op (peek opstack) postfix))
;               (get-postfix expression (pop opstack) (apply-op (peek opstack) postfix))
;             ;)
;             ;push here
;             ;OG=>(get-postfix (pop expression) (push (peek expression) opstack) postfix)
;             (get-postfix (pop expression) (push (peek expression) opstack) postfix)
;           )
;           ;push here
;           ;OG=>(get-postfix (pop expression) opstack (push (peek expression) postfix))
;           ;(get-postfix (pop expression) opstack (push (peek expression) postfix))
;           (get-postfix (pop expression) opstack (push (peek expression) postfix))
;         )
;       )
;     )
;   )
;   (define (get-postfixt expression opstack postfix)
;    ; (println opstack " : ")
;     (if (null? expression)
;       (if (null? opstack)
;         (peek postfix)
;         (get-postfix expression (pop opstack) (apply-op (peek opstack) postfix)) 
;       )
;       (begin (define sym-precedence (op-precedence (peek expression)))
;         ;(println "op: "sym-precedence " peek: " (peek expression))
;         (if (> sym-precedence 0)
;           (if (or (< sym-precedence (op-precedence (peek opstack))) );(and (= sym-precedence 3) (= sym-precedence (op-precedence (peek opstack)))))
;             (if (= sym-precedence 3)
;               ;push here
;               ;OG=>(get-postfix (pop expression) (push (peek expression) (pop opstack)) (apply-op (peek opstack) postfix))
              
;               (get-postfix (pop expression) (push (peek expression) (pop opstack)) (apply-op (peek opstack) postfix))
;               (get-postfix expression (pop opstack) (apply-op (peek opstack) postfix))
;             )
;             ;push here
;             ;OG=>(get-postfix (pop expression) (push (peek expression) opstack) postfix)
;             (get-postfix (pop expression) (push (peek expression) opstack) postfix)
;           )
;           ;push here
;           ;OG=>(get-postfix (pop expression) opstack (push (peek expression) postfix))
;           ;(get-postfix (pop expression) opstack (push (peek expression) postfix))
;           (get-postfix (pop expression) opstack (push (peek expression) postfix))
;         )
;       )
;     )
;   )
;   (flatten (get-postfix (reverse lyst) nil nil) )
;   ;(get-postfix (reverse lyst) nil nil)
; )
(define (main)
  (setPort (open (getElement ScamArgs 1) 'read))
  (println (apply infix->postfix (list (readExpr))))
)
 
(define (infix->postfix list)
  (define (rev old new)
    (cond
      ((nil? old) new)
      (else (rev (cdr old) (cons (car old) new)))
    )
  )
  (define (opCheck ch)
    (cond
      ((equal? (string ch) "+") 1)
      ((equal? (string ch) "-") 2)
      ((equal? (string ch) "*") 3)
      ((equal? (string ch) "/") 4)
      ((equal? (string ch) "^") 5)
      (else 0)
    )
  )
  (define (iter remaining ops res)
    (cond
      ((nil? remaining)
        (if (nil? ops) (rev res '())
          (iter remaining (cdr ops) (cons (car ops) res))
        )
      )
      ((< 0 (opCheck (car remaining)))
        (if (and (< 0 (length ops)) (>= (opCheck (car ops)) (opCheck (car remaining))))
          (iter remaining (cdr ops) (cons (car ops) res))
          (iter (cdr remaining) (cons (car remaining) ops) res)
        )
      )
      (else (iter (cdr remaining) ops (cons (car remaining) res)))
    )
  )
  (iter list '() '())
)
