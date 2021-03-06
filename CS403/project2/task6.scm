(define (map+ op @)
  (define (accumulate ab ugh)
    (cond
      ((null? (car ugh)) ab)
      (else
        (accumulate (append ab (list (apply op (map (lambda (x) (car x)) ugh))))
          (map (lambda (x) (cdr x)) ugh)
        )
      )
    )
  )
  (accumulate '() @)
)
(define (main)
  (setPort (open (getElement ScamArgs 1) 'read))
    (define op (readExpr))
    (define ugh (readExpr))
    (println (apply map+ (cons (eval op this) ugh)))
)