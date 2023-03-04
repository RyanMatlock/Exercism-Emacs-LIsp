;;; word-count.el --- word-count Exercise (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

(defun word-count (sentence)
  "Count the number of words in a sentence. Words can be numbers, letters, or
contractions (letters with an apostrophe), and the count is case insensitive."
  (defun alist-increment-value (key alist)
  "Increment value of key in alist; if key is not in alist, add to alist with
initial value of 1."
  (let ((entry (assoc key alist)))
    (if entry
        (progn (setcdr entry (1+ (cdr entry)))
               ;; need to return the alist because setcdr returns the cons cell
               ;; while updating the alist
               alist)
      ;; note that adding a key doesn't update the original alist the way
      ;; setcdr does; that shouldn't matter given that in either branch of the
      ;; if statement, you're returning the updated alist
      (cons (cons key 1) alist))))
  (defun wc-alist-formatter (wc-alist acc)
    (let ((entry (car wc-alist)))
      (if entry
          (let ((formatted-entry (format "%s: %d" (car entry) (cdr entry))))
            (wc-alist-formatter (cdr wc-alist) (cons formatted-entry acc)))
        ;; need to get the order right => reverse the accumulator
        (mapconcat #'identity (reverse acc) "\n"))))
  (defun wc-helper (words wc-alist)
    (let ((word (car words)))
      (if word
          (wc-helper (cdr words) (alist-increment-value word wc-alist))
        ;; to get the original sentence order
        (reverse wc-alist))))
  ;; (defun strip-punctuation (sentence)
  ;;   "Strip all punctuation except internal apostrophes from sentence."
  ;;   (replace-regexp-in-string
  ;;    "[[,.?\"!@#$%^&*()-_=+;:]][[^A-Za-z0-9]]"" " sentence))
  (defun strip-punctuation-from-word (word)
    "Strip punctuation off beginning and end of words."
    ;; so glad I found out about the [:punct:] character class
    (replace-regexp-in-string
     "[[:punct:]]+$" ""
     (replace-regexp-in-string
      "^[[:punct:]]+" "" word)))
  (let* ((words (mapcar #'downcase (split-string sentence "[[:blank:]\n]+")))
         (processed-words (mapcar #'strip-punctuation-from-word words)))
    (wc-alist-formatter (wc-helper processed-words '()))))

;; -- IELM testing --
;; ELISP> (wc-alist-formatter '(("foo" . 2) ("bar". 3)))
;; nil
;; ELISP> (wc-alist-formatter '(("foo" . 2) ("bar". 3)) '())
;; ("bar: 3" "foo: 2")
;; (wc-alist-formatter '(("foo" . 2) ("bar". 3)) '())
;; "bar: 3
;; foo: 2"
;; ELISP> (wc-alist-formatter '(("foo" . 2) ("bar". 3)) '())
;; "foo: 2
;; bar: 3"
;; ELISP> (split-string "foo   bar\nbaz" "[[:space:]]+")
;; ("foo" "bar
;; baz")
;; ELISP> (split-string "foo   bar\nbaz" "[[:blank:]]+")
;; ("foo" "bar
;; baz")
;; ELISP> (split-string "foo   bar\nbaz" "[[:blank:]\n]+")
;; ("foo" "bar" "baz")
;; ELISP> (strip-punctuation "\"That's the password: 'PASSWORD 123'!\", cried the Special Agent.\nSo I fled.")
;; "\"That's the password: 'PASSWORD 123'!\", cried the Special Agent.
;; So I fled."

;; 💡 maybe instead of stripping punctuation from a sentence, you can just
;; strip it from the words once they've been split because it will all be at
;; the beginning or the end of the word

;; ELISP> (strip-punctuation-from-word "\"There's")
;; "\"There's"
;; ELISP> (strip-punctuation-from-word "Whoa!")
;; "Whoa!"
;; regexps can be such a struggle

;; ELISP> (replace-regexp-in-string "\([[:alnum:]]+\)[[:punct:]]*" "\1" "foo")
;; "foo"
;; ELISP> (replace-regexp-in-string "\([[:alnum:]]+\)[[:punct:]]*" "\1" "bar!")
;; "bar!"
;; ELISP> (replace-regexp-in-string "foo" "bar" "foobar")
;; "barbar"
;; ELISP> (replace-regexp-in-string "[[:punct:]]" "bar" "foo!")
;; "foobar"
;; ELISP> (replace-regexp-in-string "^[[:punct:]]" "bar" "foo!")
;; "foo!"
;; ELISP> (replace-regexp-in-string "[[:punct:]]+$" "bar" "foo!")
;; "foobar"
;; ELISP> (replace-regexp-in-string "^[[:punct:]*[^[:punct:]]+[[:punct:]]*$" "bar" "foo!")
;; "foo!"
;; oh, duh, I get it; the reference groups don't make sense in this context

;; ELISP> (strip-punctuation-from-word "foo!")
;; "foo"
;; ELISP> (strip-punctuation-from-word "\"There's")
;; "There's"

;; ELISP> (word-count "That's 'a' foo-bar!")
;; ("That's" "a" "foo-bar")

;; ELISP> (setq test-cons '("a" . 2))
;; ("a" . 2)
;; ELISP> (setcdr test-cons 4)
;; 4 (#o4, #x4, ?\C-d)
;; ELISP> test-cons
;; ("a" . 4)
;; I don't *love* this because it's impure, but it doesn't look like there's a
;; better way of updating a key's value

;; ELISP> (setq test-alist '(("foo" . 1) ("bar" . 3)))
;; (("foo" . 1)
;;  ("bar" . 3))
;; ELISP> (alist-increment-value "quux" test-alist)
;; (("foo" . 1)
;;  ("bar" . 3))
;; ELISP> (alist-increment-value "quux" test-alist)
;; (("quux" . 1)
;;  ("foo" . 1)
;;  ("bar" . 3))
;; ELISP> (alist-increment-value "bar" test-alist)
;; (("foo" . 1)
;;  ("bar" . 4))
;; ELISP> test-alist
;; (("foo" . 1)
;;  ("bar" . 4))
;; ok, this is actually an acceptable way of doing it even if it's probably not
;; the most performant as the number of alist operations increases

;; ELISP> (word-count "'Egads! My roast is ruined!' exclaimed Skinner. Is it
;; though?")
;; *** Eval error ***  Wrong number of arguments: (((sentence . "'Egads! My roast is ruined!' exclaimed Skinner. Is it
;; though?") t) (wc-alist acc) (let ((entry (car wc-alist))) (if entry (let ((formatted-entry (format "%s: %d" (car entry) (cdr entry)))) (wc-alist-formatter (cdr wc-alist) (cons formatted-entry acc))) (mapconcat #'identity (reverse acc) "
;; ")))), 1
;; have fun debugging that

(provide 'word-count)
;;; word-count.el ends here
