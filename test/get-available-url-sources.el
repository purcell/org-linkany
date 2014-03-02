(require 'org-linkany)
(require 'el-expectations)

(expectations
  (desc "get-available-url-sources call init for org-linkany--org-buffer-link-alist")
  (expect (mock (org-linkany--init-source-link-in-org-buffer *))
    (let ((org-linkany/url-source-collection nil))
      (org-linkany--get-available-url-sources 'anything)))
  (desc "get-available-url-sources call init for org-linkany--other-buffer-urls")
  (expect (mock (org-linkany--init-source-url-in-other-buffer *))
    (let ((org-linkany/url-source-collection nil))
      (org-linkany--get-available-url-sources 'anything)))
  (desc "get-available-url-sources getting with generate and cache")
  (expect '(((persistent-help . "Browse this URL")
             (persistent-action lambda (cand) (funcall org-linkany/browse-function (identity cand)))
             (action . identity)
             (migemo)
             (name . "testsrc1")
             (candidates . func1))
            ((persistent-help . "Browse this URL")
             (persistent-action lambda (cand) (funcall org-linkany/browse-function (forward-char cand)))
             (action . forward-char)
             (migemo)
             (name . "testsrc2")
             (candidates . func2))
            ((persistent-help . "Browse this URL")
             (persistent-action lambda (cand) (funcall org-linkany/browse-function (backward-char cand)))
             (action . backward-char)
             (migemo)
             (name . "testsrc3")
             (candidates . func3)))
    (let* ((testsrc1 '((name . "testsrc1") (candidates . func1)))
           (testsrc2 '((name . "testsrc2") (candidates . func2)))
           (testsrc3 '((name . "testsrc3") (candidates . func3)))
           (org-linkany--available-url-sources nil)
           (org-linkany/url-source-collection '((testsrc1)
                                                (testsrc2 . forward-char)
                                                (testsrc3 . backward-char))))
      (and (eq (org-linkany--get-available-url-sources 'anything)
               org-linkany--available-url-sources)
           org-linkany--available-url-sources)))
  (desc "get-available-url-sources remove duplicate")
  (expect '(((persistent-help . "Browse this URL")
             (persistent-action lambda (cand) (funcall org-linkany/browse-function (identity cand)))
             (action . identity)
             (migemo)
             (name . "testsrc1")
             (candidates . func1))
            ((persistent-help . "Browse this URL")
             (persistent-action lambda (cand) (funcall org-linkany/browse-function (forward-char cand)))
             (action . forward-char)
             (migemo)
             (name . "testsrc2")
             (candidates . func2)))
    (let* ((testsrc1 '((name . "testsrc1") (candidates . func1)))
           (testsrc2 '((name . "testsrc2") (candidates . func2)))
           (testsrc3 '((name . "testsrc1") (candidates . func3)))
           (org-linkany--available-url-sources nil)
           (org-linkany/url-source-collection '((testsrc1)
                                                (testsrc2 . forward-char)
                                                (testsrc3 . backward-char))))
      (org-linkany--get-available-url-sources 'anything)))
  (desc "get-available-url-sources use cache")
  (expect '((hoge) (fuga))
    (let* ((testsrc1 '((name . "testsrc1") (candidates . func1)))
           (testsrc2 '((name . "testsrc2") (candidates . func2)))
           (testsrc3 '((name . "testsrc1") (candidates . func3)))
           (org-linkany--available-url-sources '((hoge) (fuga)))
           (org-linkany/url-source-collection '((testsrc1)
                                                (testsrc2 . forward-char)
                                                (testsrc3 . backward-char))))
      (org-linkany--get-available-url-sources 'anything)))
  )

