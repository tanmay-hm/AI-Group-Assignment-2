(define (domain mars-rover)
  (:requirements :strips :typing)

  (:types location rover bay drill rock - object
          soft-rock hard-rock - rock)

  (:predicates (at-rover ?r - rover ?l - location)
               (at-rock ?k - rock ?l - location)
               (at-drill ?d - drill ?l - location)
               (connected ?from ?to - location)
               (has-drill ?r - rover ?d - drill)
               (bay-empty ?b - bay)
               (bay-holds ?b - bay ?k - rock))

  (:action move
    :parameters (?r - rover ?from ?to - location)
    :precondition (and (at-rover ?r ?from) (connected ?from ?to))
    :effect (and (at-rover ?r ?to) (not (at-rover ?r ?from))))

  (:action pick-drill
    :parameters (?r - rover ?d - drill ?l - location)
    :precondition (and (at-rover ?r ?l) (at-drill ?d ?l))
    :effect (and (has-drill ?r ?d) (not (at-drill ?d ?l))))

  (:action collect-soft
    :parameters (?r - rover ?k - soft-rock ?b - bay ?l - location)
    :precondition (and (at-rover ?r ?l) (at-rock ?k ?l) (bay-empty ?b))
    :effect (and (bay-holds ?b ?k) (not (at-rock ?k ?l)) (not (bay-empty ?b))))

  (:action collect-hard
    :parameters (?r - rover ?k - hard-rock ?b - bay ?l - location ?d - drill)
    :precondition (and (at-rover ?r ?l) (at-rock ?k ?l) (bay-empty ?b)
                       (has-drill ?r ?d))
    :effect (and (bay-holds ?b ?k) (not (at-rock ?k ?l)) (not (bay-empty ?b))))

  (:action deposit
    :parameters (?r - rover ?k - rock ?b - bay ?l - location)
    :precondition (and (at-rover ?r ?l) (bay-holds ?b ?k))
    :effect (and (at-rock ?k ?l) (bay-empty ?b) (not (bay-holds ?b ?k))))
)
