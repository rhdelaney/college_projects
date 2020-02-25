(define (main)
        (setPort (open (getElement ScamArgs 1) 'read))
        (define args (readExpr))
        (println "mystery returns " (mystery (car args)))
        (println "imystery returns " (imystery (car args)))
        (println "$\\sqrt{e}$")
)
(define (mystery a)
	(define (myst i)
		(if (< i (+ a 1)) 
			(/ 1.0 (+ (+ 1.0 (* 4 (- i 1))) (/ 1.0 (+ 1 (/ 1.0 (+ 1 (myst (+ i 1))))))))
			0
		)
	)
	(+ 1 (myst 1.0))
)
(define (imystery a)
	(define(imyst depth sum)
		(if(> depth 0)
			(imyst (- depth 4) (/ 1.0 (+ depth (/ 1.0 (+ 1 (/ 1.0 (+ 1 sum)))))))
			(+ sum 1)
		)
	)
	(if(= a 0)
		(real 1)
		(imyst (+ 1 (* 4 (- a 1))) 0)
	)
)