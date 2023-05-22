;;; rotational-cipher.el --- Rotational Cipher (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:


(defun rotate (text shift-key)
  "Take modulo 26 of the sum of number SHIFT-KEY (between 0 and 26) and each
letter char in string TEXT and return the result as a string."

  (defun shift (char shift-key first-letter)
    (+ (mod (+ (- char first-letter) shift-key) 26)
       first-letter))

  (let ((uppercase (number-sequence ?A ?Z))
        (lowercase (number-sequence ?a ?z)))
    (mapconcat
     #'string
     (seq-map #'(lambda (c)
                  (cond ((member c uppercase) (shift c shift-key ?A))
                        ((member c lowercase) (shift c shift-key ?a))
                        (t c)))
              text)
     "")))


(provide 'rotational-cipher)
;;; rotational-cipher.el ends here
