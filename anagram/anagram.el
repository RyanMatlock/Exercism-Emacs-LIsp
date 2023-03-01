;;; anagram.el --- Anagram (exercism)  -*- lexical-binding: t; -*-

;;; Commentary:

(defun anagrams-for (subject candidates)
  "Determine which, if any, of the words in candidates are anagrams of
subject."
  (defun word-to-letters-signature (word)
    "Convert a word to an alphabetically ascending list of letters, including
repeats.

Words that are anagrams should possess the same ordered letter list,
e.g. 'stop' and 'pots' should both produce ('o' 'p' 's' 't')."
    ;; technically, the outer mapcar isn't necessary, but the output is chars
    ;; AKA ints, so converting them to strings makes debugging easier
    (sort (mapcar #'string (mapcar #'identity (downcase word)))
          'string<))
  (defun identical-letter-list-p (xs ys)
    "Determine if two ordered lists of lowercase letters *of same length* are
identical. anagrams-p will ensure that they're the same length."
    (if (and xs ys)
        (and
         ;; check that first elements are the same
         (string= (car xs) (car ys))
         ;; recursive step
         (identical-letter-list-p (cdr xs) (cdr ys)))
      ;; if xs and ys are empty, then you've made it to the end without
      ;; differences, so they're the same => t
      t))
  (defun anagrams-p (subj cand)
    "Determine if cand is an anagram of subj."
    (and (not (string= (downcase subj) (downcase cand)))
         (eq (length subj) (length cand))
         (identical-letter-list-p (word-to-letters-signature subj)
                                  (word-to-letters-signature cand))))
  (defun anagrams-for-helper (subject candidates anagrams)
    "Build a list of anagrams of subject from candidates."
    ;; only using nested if statements instead of cond due to let statement
    ;; if candidates is nil, you can't take the cdr of it
    (if candidates
        (let ((candidate (car candidates))
              (rest (cdr candidates)))
          (if (anagrams-p subject candidate)
              (anagrams-for-helper subject rest (cons candidate anagrams))
            (anagrams-for-helper subject rest anagrams)))
      ;; return anagrams when out of candidates
      ;; reverse anagrams to present them in order found in candidates
      (reverse anagrams)))
  (anagrams-for-helper subject candidates '()))

(provide 'anagram)
;;; anagram.el ends here
