(defun db/mastodon-open-url-in-toot()
  ;; opens any link present in the toot without having to mouse it or move point to it. 
  (interactive)
  (save-excursion
    (mastodon-tl--goto-prev-toot)
    ;; copy the region
    (mastodon-tl--goto-next-toot))
  ;; extract url
  ;; (mastodon-url-lookup &optional QUERY-URL)
  )
