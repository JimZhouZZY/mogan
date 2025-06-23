
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : tabpage-menu.scm
;; DESCRIPTION : The tab bar below the main icon bar
;; COPYRIGHT   : (C) 2024 Zhenjun Guo
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (texmacs menus tabpage-menu)
  (:use (kernel gui menu-widget)
        (texmacs menus file-menu)))

(import (only (srfi srfi-1) list-index))

;; TODO: refactor this to use view-list-unsorted instead of buffer-menu-unsorted-list
(tm-define (move-buffer-to-index buf j)
  (define (transform lst index) (- (length lst) 1 index))
  ;; lst is the reversed buffer list of cpp buffer array
  (let* ((lst  (buffer-menu-unsorted-list 99))
         ;; so we need to transform the index to true index in cpp buffer array
         (from (transform lst (list-index (lambda (x) (== x buf)) lst)))
         (to   (transform lst j)))
      (move-buffer-index from to)))

(tm-menu (texmacs-tab-pages)
  (for (view (view-list-unsorted)) ; buf is the url
    (let* ((buf (view->buffer view))
           (cur-win (current-window))
           (view-win (view->window-tabpage view)))
           ;; display cur-win and windows for debugging
      ;(display* "cur-win: " cur-win "\n")
      ;(display* "windows: " windows "\n")
      (if (equal? view-win cur-win)
          (let* ((title  (buffer-get-title buf))
                 (title* (if (== title "") (url->system (url-tail buf)) title))
                 (mod?   (buffer-modified? buf))
                 (tab-title (string-append title* (if mod? " *" "")))
                 (doc-path  (url->system buf))
                 (active?   (== (current-buffer) buf)))
            (tab-page
              (eval buf)
              ((balloon (eval `(verbatim ,tab-title)) (eval `(verbatim ,doc-path))) (window-set-view view-win view #t))
              ((balloon "✕" "Close") (safely-kill-tabpage-by-url view-win view buf))
              (eval active?)
            ))))))