;; not wrong per se, but overly complicated -- no need to use alists

;; how to form a cons cell
;; (message (format "%s" (cons "a" 2)))  ;; (a . 2)

;; (message (format "car of nil: '%s'" (car '())))  ;; nil

;; (message (format "car of 'apple': '%s'" (car "apple")))
;; format: Wrong type argument: listp, "apple"
;; you need to start using 「M-x ielm」 to test out Emacs Lisp

;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Sequences-Arrays-Vectors.html
;; strings are a subset of arrays, and lists and arrays are a subset of
;; sequences

;; (mapcar #'identity "apple")
;; (97 112 112 108 101)
;; (mapcar #'string '(97 112 112 108 101))
;; ("a" "p" "p" "l" "e")

;; (sort '(("a" . 1) ("p" . 2) ("l" . 1) ("e" . 1)) '(lambda (x y)
;;                                                            (< (car x) (car y))))
;; *** Eval error ***  Wrong type argument: number-or-marker-p, "p"

;; (print (sort '(("a" . 1) ("p" . 2) ("l" . 1) ("e" . 1))
;;                     '(lambda (x y)
;;                        (string< (car x) (car y)))))

;; (("a" . 1) ("e" . 1) ("l" . 1) ("p" . 2))

;; (print (sort-alist '(("a" . 1) ("p" . 2) ("l" . 1) ("e" . 1))
;;                           'string<))

;; (("a" . 1) ("e" . 1) ("l" . 1) ("p" . 2))

(defun anagrams-for (subject candidates)
  "Determine which, if any, of the words in candidates are anagrams of
subject."
  ;; seems like something like this should be built in, but I couldn't find it
  (defun string-to-letters (str)
    "Example: convert 'apple' to ('a' 'p' 'p' 'l' 'e')."
    (mapcar #'string (mapcar #'identity str)))
  (defun sort-alist (alist comparison)
    "Sort association list using function comparison (e.g. for alists with keys
of type string, you'd pass string< for an ascending list)."
    (sort alist #'(lambda (x y)
                    (funcall comparison (car x) (car y)))))
  (defun count-letters (word)
    "Counts instances of each letter in a given word and returns an association
list, e.g. apple:
'((a . 1)
  (e . 1)
  (l . 2
  (p . 2))
[note: sorting the list alphabetically should make comparision easier]"
    (let* ((lcase-word (downcase word))
           (letters ))
      ))
  (defun anagrams-for-helper (subject candidates anagrams)
    "Build a list of anagrams of subject from candidates."
    ;; (let ((dsubject (downcase subject))
    ;;       (candidate (car candidates))))
    (cond
     ;; when out of candidates, return anagrams
     ((not candidates) anagrams)
     ;; if subject and candidate are different lengths, they can't be anagrams
     ((/= (length subject) (length (car candidates)))
      (anagrams-for-helper subject (cdr candidates) anagrams))
     ;; if subject is identical to candidate, they are not anagrams
     ((string= (downcase subject) (cons (downcase candidates)))
      (anagrams-for-helper subject (car candidates) anagrams))))
  (anagrams-for-helper subjects candidates '()))

;; (word-to-letters-signature "stop")
;; ("o" "p" "s" "t")
;; (word-to-letters-signature "pots")
;; ("o" "p" "s" "t")
;; (defun w2s (x) (sort (mapcar #'identity (downcase x))
;;                             '<))
;; w2s
;; (w2s "stop")
;; (111 112 115 116)

;; ELISP> (not '())
;; t
;; ELISP> (not '("a" "b"))
;; nil
;; ELISP> (and (not '()) (not '()))
;; t
;; ELISP> (and (not '()) (not '("a" "b")))
;; nil

;; ELISP> (identical-letter-list-p '("a" "b") '("a" "c"))
;; nil
;; ELISP> (identical-letter-list-p '("a" "b") '("a" "b"))
;; t
;; ELISP> (identical-letter-list-p (word-to-letters-signature "stop")
;; (word-to-letters-signature "pots"))
;; t

(defun identical-letter-list-p (xs ys)
  "Determine if two ordered lists of lowercase letters are identical."
  ;; there's probably a cleverer way of doing this with and and/or or
  ;; functions and omitting the cond entirely
  (cond
   ;; if xs and ys are empty, then they're the same
   ((and (not xs) (not ys)) t
    ;; redundant
    ;; ;; if xs and ys are different lengths, they're not the same
    ;; ((not (eq (length xs) (length ys))) nil)
    ;; if the first element is different, they're not the same
    ((not (string= (car xs) (car ys))) nil)
    ;; recursive step: check next eleemnt
    (t identical-letter-list-p (cdr xs) (cdr ys)))))

;; bug in here
(defun identical-letter-list-p (xs ys)
  "Determine if two ordered lists of lowercase letters are identical."
  (if (and xs ys)
      (and
       ;; check that first elements are the same
       (string= (car xs) (car ys))
       ;; recursive step
       (identical-letter-list-p (cdr xs) (cdr ys)))
    ;; if xs and ys are empty, then you've made it to the end without
    ;; differences, so they're the same => t
    t))

;; weird: it's failing
;; (anagrams-for "good" '("dog" "goody"))
;; ("dog" "goody")

;; ELISP> (anagrams-p "good" "dog")
;; t
;; ELISP> (anagrams-p "good" "goody")
;; t
;; weirder

;; ELISP> (word-to-letters-signature "good")
;; ("d" "g" "o" "o")
;; ELISP> (word-to-letters-signature "dog")
;; ("d" "g" "o")
;; ELISP> (word-to-letters-signature "goody")
;; ("d" "g" "o" "o" "y")
;; so it must be stopping at ("d" "g" "o")

;; the issue was that if the lists weren't the same length,
;; identical-letter-list-p returned t, so to make things easy, I'll only pass
;; in lists of same length
