(define (main)
        (setPort (open (getElement ScamArgs 1) 'read))
        (println (apply root12 (readExpr)))
        )
(define (root12 n)
	(^ n (/ 1.0000000000 12.0000000000))
	;(/ n n n n n n n n n n n n)
) 