; (define (main)
;   ; all these should be the same
;   ;guard ->blocking it from printing
;   ;catch needs to be in the body of this function
;   ;(define (catch f)

;    ; (throw 'MALFORMED_FUNCTION_CALL "too many arguments")
;    ; (throw 'MALFORMED_FUNCTION_CALL "too few arguments")
;   ;)
;   ;(catch ((pfa (lambda (a b c) (+ a b c)) 40) 61 -83 40))
;   ;   (define (catch g) 
;   ;   (if (error? g)
;   ;     (throw 'MALFORMED_FUNCTION_CALL)
;   ;   )
;   ; )
;   ;(println (catch ((pfa (lambda (a b c) (+ a b c) ) 68) -22 56)))
;   (setPort (open (getElement ScamArgs 1) 'read))
;   (define f (readExpr))
;   (define first (readExpr))
;   (define second (readExpr))
;   (define f1 (apply pfa (cons (eval f this) first) ))
;   (define f2 (apply f1 second))
;   (println f2)
; )
; ; (define (pfa f @)
; ;   (define (correct-length? lyst)
; ;     (= (length (get 'parameters f)) (length lyst))
; ;   )
; ;   (define (get-args @)
; ;     (define args @)
; ;     (if (correct-length? args)
; ;       (apply f args)
; ;       (lambda (@) (apply get-args (append args @)))
; ;     )
; ;   )
; ;   (apply get-args @)
; ; )
; (define (pfa @)
;   (let ((outer @))
;     (lambda (@)(apply (car outer) (append (cdr outer) @)))
;   )
; )
(define (main)
  (setPort (open (getElement ScamArgs 1) 'read))
  (println (apply (apply pfa (cons (eval (readExpr) this) (readExpr))) (readExpr)))
)
 
(define (pfa f @)
  (define (iter f argv argc)
    (if (null? argv)
      (lambda (@)
        (cond
          ((> (length @) argc) (throw 'MALFORMED_FUNCTION_CALL "too many arguments"))
          ((< (length @) argc) (throw 'MALFORMED_FUNCTION_CALL "too few arguments"))
          (else (apply f @))
        )
      )
      (iter (lambda (@) (apply f (cons (car argv) @))) (cdr argv) argc)
    )
  )
  (if (> (length @) (length (get 'parameters f)))
    (throw 'MALFORMED_FUNCTION_CALL "too many arguments")
    (iter f @ (- (length (get 'parameters f)) (length @)))
  )
)