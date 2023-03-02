;;; all-your-base.el --- All Your Base (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:

(defun rebase (list-of-digits in-base out-base)
  ;; this is just all wrong
  (defun __base10-to-base-n (__base10-digits n)
    "Convert list of digits in base-10 to list of digits in base-n."
    (defun __base10-to-base-n-helper (__base10-num n power accumulator)
      (if (eq __base10-num 0)
          accumulator
        (let* ((divisor (expt n power))
               ;; (remainder (mod __base10-num divisor))
               (remainder (% __base10-num divisor))
               (quotient (/ __base10-num divisor)))
          (__base10-to-base-n-helper
           quotient
           n
           (1+ power)
           (cons remainder accumulator)))))
    (let ((__base10-number (string-to-number
                            (mapconcat #'number-to-string __base10-digits ""))))
      (__base10-to-base-n-helper __base10-number n 0 '())))
  (defun __base-n-to-base10 (__base-n-digits n accumulator)
    "Convert list of digits in base-n to base-10."
    (if __base-n-digits
        (let ((power (1- (length __base-n-digits)))
              (x (car __base-n-digits)))
          ;; recursive step
          (__base-n-to-base10
           (cdr __base-n-digits)
           n
           (cons (* x (expt n power)) accumulator)))
      (apply #'+ accumulator)))
  (error "Delete this S-Expression and write your own implementation"))

;; -- IELM testing --
;; ELISP> (string-to-number (mapconcat #'identity '("3" "1" "0") ""))
;; 310 (#o466, #x136)
;; ELISP> (string-to-number (mapconcat #'string '(4 2) ""))
;; 0 (#o0, #x0, ?\C-@)
;; ELISP> (string-to-number (mapconcat #'identity (mapcar #'string '(4 2)) ""))
;; 0 (#o0, #x0, ?\C-@)
;; ELISP> (string-to-number (mapconcat #'number-to-string '(4 2) ""))
;; 42 (#o52, #x2a, ?*)

(provide 'all-your-base)
;;; all-your-base.el ends here
