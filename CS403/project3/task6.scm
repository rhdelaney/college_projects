; (define (stream-for-each proc s times)
;     (if (eq? times 0)
;         'done
;         (begin (proc (stream-car s))
;             (stream-for-each proc (stream-cdr s) (- times 1)))))

(define (stream-display n s)
  (define (helper t c)
    (if (= c 0)
      'OK
      (begin
        (print (stream-car t) " ")
        (helper (stream-cdr t) (- c 1))
        )
      )
    )
  (print "(")
  (helper s n)
  (print "...)")
)
(define scons cons-stream)
(define scar stream-car)
(define scdr stream-cdr)
(define (stream-scale number stream)
    (scons (* number (scar stream)) (stream-scale number (scdr stream)))
) 
(define (stream-merge s1 s2)
    (cond
        ((< (scar s1) (scar s2)) (scons (scar s1) (stream-merge (scdr s1) s2)))
        ((> (scar s1) (scar s2)) (scons (scar s2) (stream-merge s1 (scdr s2))))
        (else
            (scons (scar s1) (stream-merge (scdr s1) (scdr s2)))
        )
    )
)

(define (pfs @)
    (define (iter currS rList)
        (cond
            ((not (null? rList)) (stream-merge (stream-scale currS s) (iter (car rList) (cdr rList))))
            (else
                (stream-scale currS s)
            )
        )
    )
    (scdr (define s (scons 1 (iter (car @) (cdr @) ))))
)

(define (main)
    (setPort (open (getElement ScamArgs 1) 'read))
    (define f (readExpr))
    (define n (readExpr))
    ;(println (primeFactors 8))
    ;(define (pfs n))
    (stream-display f (pfs n))
    (println)
    )