//
//  ConfigBundle.swift
//  Core
//
//  Created by Komsit Chusangthong on 5/4/20.
//  Copyright © 2020 Komsit Chusangthong. All rights reserved.
//

public struct ConfigBundle {
    /* Example for creating a bundle set */
    /*static var trueyou: Bundle = Bundle(identifier: "com.komsit.ghostnight.Component")!*/
    public static var ghostNightMain: Bundle = .main
    // Player
    public static var ghostNightPlayer: Bundle = Bundle(identifier: "com.komsit.ghostnight.GhostNightPlayer")!
    // Component
    public static var component: Bundle = Bundle(identifier: "com.komsit.ghostnight.Component")!
}
