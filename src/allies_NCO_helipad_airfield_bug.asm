; If you play as Allies, capture a Soviet Construction yard and build or capture a Helipad and Airfield if do you anything that causes the game to recheck what stuff needs to be removed from the sidebar, the game thinks the Hind and Transport Helicopter aren't buildable and removes it from the sidebar, then re-adds it to the sidebar after the game checks what stuff is buildable again. That's because there's two different checks and the check fails when checking what to remove.

; The Hind and Transport Helicopter require the Helipad and have Soviet as owner, if you have the Construction Yards for both teams you won't be able to build these units after building a Helipad, After getting the Airfield one of the checks thinks you can build Hind and Transport Helicopter and the other thinks you can't. We patch in a special exception for this

; Fix will desync online with 3.03 most likely in the very rare occasion that this situation occurs. That's because Hind and Transport Helicopter will spawn for players with this fix but without those two helicopters won't spawn because both the Helipad and Airfield aren't considered valid factories for those two helicopters in this situation.

;@CLEAR 0x0051EBBD 0x90 0x0051EBC2
