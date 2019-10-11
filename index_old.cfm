<cfscript>
    
    WavBuilder = new com.coldfumonkeh.CFWavPlayer.WavBuilder();

    player1 = WavBuilder
        .new()
        .file( './wav_audio.wav' );
    duration = player1.getDuration();

    player1.play();


    player2 = WavBuilder
        .new()
        .file( './bird_chirping.wav' )
        .loop()
        .wait( int( duration * 0.001 ) )
        .stop();

    // abort;

    // Plays sounds in parallel
    objCFWavPlayer = new com.coldfumonkeh.CFWavPlayer.CFWavPlayer();
    objCFWavPlayer.file( './wav_audio.wav' );
    duration = objCFWavPlayer.getDuration();

    objCFWavPlayer.play();

    objCFWavPlayer2 = new com.coldfumonkeh.CFWavPlayer.CFWavPlayer();
    objCFWavPlayer2
        .file( './bird_chirping.wav' )
        .loop()
        .wait( int( duration * 0.001 ) )
        .stop();

    

    // objCFWavPlayer2.play();

    // objCFWavPlayer.stop();

    /*

    writedump( objCFWavPlayer.getStatus() );
    writedump( objCFWavPlayer.getCurrentFrame() );

    objCFWavPlayer.pause();

    writedump( objCFWavPlayer.getStatus() );
    writedump( objCFWavPlayer.getCurrentFrame() );

    objCFWavPlayer.stop();

    writedump( objCFWavPlayer.getStatus() );
    writedump( objCFWavPlayer.getCurrentFrame() );

    objCFWavPlayer.restart();

    writedump( objCFWavPlayer.getStatus() );
    writedump( objCFWavPlayer.getCurrentFrame() );

    */

    /*
    objCFWavPlayer
        .file( './wav_audio.wav' )
        .play()
        .wait( 5000 )
        .stop();
    */

</cfscript>