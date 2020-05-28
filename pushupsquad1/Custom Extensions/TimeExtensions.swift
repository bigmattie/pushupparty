//
//  TimeExtensions.swift
//  pushupsquad1
//
//  Created by Matthew Manning on 5/27/20.
//  Copyright © 2020 Matthew Manning. All rights reserved.
//

import Foundation

import Foundation

public func secondsToHoursMinutesSeconds (seconds : Int) -> String {
    //calculation for Hours minutes in seconds in Int form
    let rawHours = seconds / 3600
    let rawMinutes = (seconds % 3600) / 60
    let rawSeconds  =  (seconds % 3600) % 60
    var hours = ""
    var minutes = ""
    var seconds = ""
   
   //pretty Logic for values less than 10 to create 00:05 effect instead of 0:5 (Hours and seconds example)
        if (rawHours < 10) {
            hours = "0" + String(rawHours)
        } else {
        hours = String(rawHours)
        }
        if (rawMinutes < 10) {
            minutes = "0" + String(rawMinutes)
        } else {
        minutes = String(rawMinutes)
        }
        if (rawSeconds < 10) {
            seconds = "0" + String(rawSeconds)
        } else {
        seconds = String(rawSeconds)
        }
//Returning string
//If there are no hours then return only minutes and seconds
    if ( rawHours == 0) {
  let output = String(minutes) + ":" + String(seconds)
  return output
    } else {
        //if there is an hour value retunn Hours minutes and seconds
 let output = String(hours) + ":" + String(minutes) + ":" + String(seconds)
 return output
    }
}

