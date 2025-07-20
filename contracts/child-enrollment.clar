;; Child Enrollment Contract
;; Manages daycare registration and requirements

;; Error constants
(define-constant ERR-NOT-AUTHORIZED (err u200))
(define-constant ERR-CHILD-EXISTS (err u201))
(define-constant ERR-CHILD-NOT-FOUND (err u202))
(define-constant ERR-INVALID-AGE (err u203))
(define-constant ERR-INVALID-INPUT (err u204))
(define-constant ERR-ENROLLMENT-CLOSED (err u205))

;; Data variables
(define-data-var contract-owner principal tx-sender)
(define-data-var next-child-id uint u1)
(define-data-var enrollment-open bool true)

;; Data maps
(define-map children
  { child-id: uint }
  {
    name: (string-ascii 100),
    age: uint,
    health-info: (string-ascii 300),
    parent: principal,
    caregiver-id: (optional uint),
    enrolled: bool,
    enrollment-date: uint
  }
)

(define-map children-by-parent
  { parent: principal, child-name: (string-ascii 100) }
  { child-id: uint }
)

;; Read-only functions
(define-read-only (get-child (child-id uint))
  (map-get? children { child-id: child-id })
)

(define-read-only (get-child-by-parent (parent principal) (child-name (string-ascii 100)))
  (match (map-get? children-by-parent { parent: parent, child-name: child-name })
    child-data (get-child (get child-id child-data))
    none
  )
)

(define-read-only (is-child-enrolled (child-id uint))
  (match (get-child child-id)
    child-data (get enrolled child-data)
    false
  )
)

(define-read-only (is-enrollment-open)
  (var-get enrollment-open)
)

(define-read-only (get-child-caregiver (child-id uint))
  (match (get-child child-id)
    child-data (get caregiver-id child-data)
    none
  )
)

;; Public functions
(define-public (enroll-child (name (string-ascii 100)) (age uint) (health-info (string-ascii 300)) (parent principal))
  (let
    (
      (child-id (var-get next-child-id))
    )
    (asserts! (var-get enrollment-open) ERR-ENROLLMENT-CLOSED)
    (asserts! (> (len name) u0) ERR-INVALID-INPUT)
    (asserts! (and (>= age u0) (<= age u18)) ERR-INVALID-AGE)
    (asserts! (is-none (map-get? children-by-parent { parent: parent, child-name: name })) ERR-CHILD-EXISTS)

    (map-set children
      { child-id: child-id }
      {
        name: name,
        age: age,
        health-info: health-info,
        parent: parent,
        caregiver-id: none,
        enrolled: true,
        enrollment-date: block-height
      }
    )

    (map-set children-by-parent
      { parent: parent, child-name: name }
      { child-id: child-id }
    )

    (var-set next-child-id (+ child-id u1))
    (ok child-id)
  )
)

(define-public (assign-caregiver (child-id uint) (caregiver-id uint))
  (let
    (
      (child-data (unwrap! (get-child child-id) ERR-CHILD-NOT-FOUND))
    )
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)

    (map-set children
      { child-id: child-id }
      (merge child-data { caregiver-id: (some caregiver-id) })
    )
    (ok true)
  )
)

(define-public (update-child-info (child-id uint) (health-info (string-ascii 300)))
  (let
    (
      (child-data (unwrap! (get-child child-id) ERR-CHILD-NOT-FOUND))
    )
    (asserts! (is-eq tx-sender (get parent child-data)) ERR-NOT-AUTHORIZED)

    (map-set children
      { child-id: child-id }
      (merge child-data { health-info: health-info })
    )
    (ok true)
  )
)

(define-public (unenroll-child (child-id uint))
  (let
    (
      (child-data (unwrap! (get-child child-id) ERR-CHILD-NOT-FOUND))
    )
    (asserts! (or (is-eq tx-sender (get parent child-data)) (is-eq tx-sender (var-get contract-owner))) ERR-NOT-AUTHORIZED)

    (map-set children
      { child-id: child-id }
      (merge child-data { enrolled: false, caregiver-id: none })
    )
    (ok true)
  )
)

(define-public (toggle-enrollment)
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (var-set enrollment-open (not (var-get enrollment-open)))
    (ok (var-get enrollment-open))
  )
)
