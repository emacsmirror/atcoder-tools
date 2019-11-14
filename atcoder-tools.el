;; -*- lexical-binding: t -*-
;;; atcoder-tools.el --- atcoder-tools client

;; Copyright (c) 2019 Seong Yong-ju

;; Author: Seong Yong-ju <sei40kr@gmail.com>
;; Keywords: extensions, tools
;; URL: https://github.com/sei40kr/atcoder-tools
;; Package-Requires: ((emacs "26"))
;; Version: 0.1.0

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:
;;; Code:

(defgroup atcoder-tools nil
  "atcoder-tools client"
  :prefix 'atcoder-tools-
  :group 'tools)

(defcustom atcoder-tools-rust-use-rustup t
  "If non-nil, compile Rust files using rustup.")

(defvar atcoder-tools--rust-version "1.15.1")

(defun atcoder-tools--rust-compile-command (input-file-name output-file-name)
  (if atcoder-tools-rust-use-rustup
      (format "rustup run --install %s rustc -o %s %s"
              (shell-quote-argument atcoder-tools--rust-version)
              (shell-quote-argument output-file-name)
              (shell-quote-argument input-file-name))
    (format "rustc -o %s %s"
            (shell-quote-argument output-file-name)
            (shell-quote-argument input-file-name))))

(defun atcoder-tools--compile-command (mode input-file-name output-file-name)
  (pcase mode
    (`rust-mode (atcoder-tools--rust-compile-command input-file-name
                                                     output-file-name))
    ))

(defun atcoder-tools--test-command (mode input-file-name output-file-name)
  (pcase mode
    (`rust-mode (format "atcoder-tools test --exec=%s --dir=%s"
                        (shell-quote-argument output-file-name)
                        (shell-quote-argument
                         (file-name-directory input-file-name))))
    ))

;;;###autoload
(defun atcoder-tools-browse-problem ()
  (interactive)
  (let* ((metadata-file-name (concat (file-name-directory (buffer-file-name))
                                     "metadata.json"))
         (metadata-alist (if (file-readable-p metadata-file-name)
                             (json-read-file metadata-file-name)
                           (error "Could not retrieve information from metadata.json.")))
         (problem-alist (alist-get 'problem metadata-alist))
         (contest-id (alist-get 'contest_id (alist-get 'contest problem-alist)))
         (problem-id (alist-get 'problem_id problem-alist)))
    (browse-url (format "https://atcoder.jp/contests/%s/tasks/%s"
                        contest-id
                        problem-id))))

;;;###autoload
(defun atcoder-tools-test ()
  (interactive)
  (let* ((input-file-name (buffer-file-name))
         (output-file-name (file-name-sans-extension (buffer-file-name)))
         (compile-command (atcoder-tools--compile-command major-mode
                                                          input-file-name
                                                          output-file-name))
         (test-command (atcoder-tools--test-command major-mode
                                                    input-file-name
                                                    output-file-name)))
    (compile (format "%s && %s" compile-command test-command))))

(provide 'atcoder-tools)
