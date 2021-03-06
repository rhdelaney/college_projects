(define (main)
  (setPort (open (getElement ScamArgs 1) 'read))
  (define f (readExpr))
  (println (infix->postfix f))
  ;(println (infix->postfix '(2 + 3 * x ^ 5 + a)))
  ;Basically it thinks 'a' is a symbol/operation which I guess technically it kinda is in scheme
  ; so basically add a proper conditional check -> (if (operation in) else( treat like integer)) 
 ;(inspect (infix->postfix '(4 * 6 / 2 * 6)))
  ;(println "\tIt should be (* (/ (* 4 6) 2) 6)")
  ;(inspect (infix->postfix '(2 + 3 * x ^ 5 ^ 3 + a)))
  ;(println "\tIt should be (+ (+ 2 (* 3 (^ x (^ 5 3)))) a)")
)

(define (push item stack)
  ;(println "push= " stack)
  (cons item stack)
)

(define (peek stack)
  ;(println "peek= " stack)
  (if (null? stack)
    nil
    (car stack)
  )
)

(define (pop stack)
  ;(println "pop= " stack)
  (if (null? stack)
    nil
    (cdr stack)
  )
)

(define (infix->postfix lyst)
  (define (op-precedence sym)
    (if (or (equal? sym '+) (equal? sym '-))
      1
      (if (or (equal? sym '*) (equal? sym '/))
        2
        (if (equal? sym '^)
          3
          0
        )
      )
    )
  )
  (define (apply-op op stack)
    ;(println "app-op= " op " : " stack)
    (push (list (peek stack) (peek (pop stack)) op) (pop (pop stack)))
    ;(push (list op (peek stack) (peek (pop stack))) (pop (pop stack)))
  )
  (define (get-postfix expression opstack postfix)
    ;(println expression " : " opstack " : " postfix)
    (if (null? expression)
      (if (null? opstack)
        (peek postfix)
        (get-postfix expression (pop opstack) (apply-op (peek opstack) postfix))
      )
      (begin (define sym-precedence (op-precedence (peek expression)))
        (if (> sym-precedence 0)
          (if (or (< sym-precedence (op-precedence (peek opstack))) (and (= sym-precedence 3) (= sym-precedence (op-precedence (peek opstack)))))
            (if (= sym-precedence 3)
              ;push here
              ;OG=>(get-postfix (pop expression) (push (peek expression) (pop opstack)) (apply-op (peek opstack) postfix))
              (get-postfix (pop expression) (push (peek expression) (pop opstack)) (apply-op (peek opstack) postfix))
              (get-postfix expression (pop opstack) (apply-op (peek opstack) postfix))
            )
            ;push here
            ;OG=>(get-postfix (pop expression) (push (peek expression) opstack) postfix)
            (get-postfix (pop expression) (push (peek expression) opstack) postfix)
          )
          ;push here
          ;OG=>(get-postfix (pop expression) opstack (push (peek expression) postfix))
          (get-postfix (pop expression) opstack (push (peek expression) postfix))
        )
      )
    )
  )
  (get-postfix (reverse lyst) nil nil)
)
