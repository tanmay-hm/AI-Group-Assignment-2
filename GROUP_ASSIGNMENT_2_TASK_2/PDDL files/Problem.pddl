(define (problem mars-rover-1)
  (:domain mars-rover)

  (:objects base sitea siteb sitec sited sitee sitef - location
            curiosity - rover
            bay1 bay2 - bay
            drill1 - drill
            rock1 rock2 rock4 - soft-rock
            rock3 rock5 - hard-rock)

  (:init (at-rover curiosity base)
         (at-drill drill1 sitee)
         (at-rock rock1 sitea)
         (at-rock rock2 siteb)
         (at-rock rock3 sitec)
         (at-rock rock4 sited)
         (at-rock rock5 sitef)
         (bay-empty bay1) (bay-empty bay2)

         (connected base sitea) (connected sitea base)
         (connected base siteb) (connected siteb base)
         (connected sitea sitec) (connected sitec sitea)
         (connected siteb sited) (connected sited siteb)
         (connected sitec sitee) (connected sitee sitec)
         (connected sited sitee) (connected sitee sited)
         (connected sitee sitef) (connected sitef sitee)
         (connected sitec sited))

  (:goal (and (at-rock rock1 base) (at-rock rock2 base) (at-rock rock3 base)
              (at-rock rock4 base) (at-rock rock5 base)
              (bay-empty bay1) (bay-empty bay2)
              (at-rover curiosity base)))
)
