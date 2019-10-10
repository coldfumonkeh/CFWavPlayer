/**
* Name: CFWavPlayer.cfc
* Author: Matt Gifford (https://www.monkehworks.com)
* Date: 10th October 2019
*/
component accessors="true" {

    property name="currentFrame" type="numeric" default="0";
    property name="clip" type="any";
    property name="audioInputStream" type="any";
    property name="status" type="string";
    property name="filePath" type="string";

    variables.fileReader                    = createObject( "java", "java.io.File" );
    variables.AudioInputStream              = createObject( "java", "javax.sound.sampled.AudioInputStream" );
    variables.Clip                          = createObject( "java", "javax.sound.sampled.Clip" );
    variables.LineUnavailableException      = createObject( "java", "javax.sound.sampled.LineUnavailableException" );
    variables.UnsupportedAudioFileException = createObject( "java", "javax.sound.sampled.UnsupportedAudioFileException" );
    variables.AudioSystem                   = createObject( "java", "javax.sound.sampled.AudioSystem" );

    /**
    * Instantiate the component
    */
    CFWavPlayer function init(){
        return this;
    }

    /**
    * Sets a file into the audio player
    * 
    * @filePath The full path to the wav file
    */
    CFWavPlayer function file( required string filePath ){
        setFilePath( arguments.filePath );
        setStatus( 'File loaded: ' & arguments.filePath );
        resetAudioStream();
        return this;
    }

    /**
    * Plays the audio
    */
    CFWavPlayer function play(){
        var clip = getClip();
        // start the clip
        clip.start();
        setClip( clip );
        setStatus( 'playing' );
        return this;
    }

    /**
    * Pauses the audio
    */
    CFWavPlayer function pause(){
        if( getStatus() == 'paused' ){
            // audio is already paused
            return this;
        }
        var clip = getClip();
        setCurrentFrame( clip.getMicrosecondPosition() );
        clip.stop();
        setClip( clip );
        setStatus( 'paused' );
        return this;
    }

    /**
    * Resumes the audio
    */
    CFWavPlayer function resume(){
        if( getStatus() == 'playing' ){
            // audio is already playing
            return this;
        }
        var clip = getClip();
        clip.close();
        resetAudioStream();
        clip.setMicrosecondPosition( getCurrentFrame() );
        setClip( clip );
        play();
        return this;
    }

    /**
    * Restarts the audio
    */
    CFWavPlayer function restart(){
        var clip = getClip();
        clip.stop();
        resetAudioStream();
        var currFrame = javaCast( 'long', 0 );
        setCurrentFrame( currFrame );
        clip.setMicrosecondPosition( currFrame );
        setClip( clip );
        play();
        return this;
    } 

    /**
    * Stops the audio
    */
    CFWavPlayer function stop(){
        setCurrentFrame( javaCast( 'long', 0 ) );
        var clip = getClip();
        clip.stop();
        clip.close();
        setClip( clip );
        setStatus( 'stopped' );
        return this;
    }

    /**
    * Will ensure the audio never stops playing, EVER, until you call the `.stop` method.
    */
    CFWavPlayer function loop(){
        var clip = getClip()
        clip.loop( clip.LOOP_CONTINUOUSLY );
        setClip( clip );
        return this;
    }

    /**
    * Will attempt to jump to a specific point in the audio
    * 
    * @position The position in the audio to jump to in microseconds
    */
    CFWavPlayer function jumpTo( required numeric position ){
        var pos = javaCast( 'long', arguments.position );
        var clip = getClip();
        if( pos > 0 && pos < clip.getMicrosecondLength() ){ 
            clip.stop(); 
            // clip.close();
            resetAudioStream(); 
            setCurrentFrame( pos );
            clip.setMicrosecondPosition( pos );
            setClip( clip );
            // play();
        }
        return this;
    }

    /**
    * Helper method to set a delay before performing the next action
    * 
    * @duration Number of microseconds to wait
    */
    CFWavPlayer function wait( required numeric duration ){
        sleep( arguments.duration );
        return this;
    }

    /**
    * Returns the duration of the active audio file in microseconds
    */
    numeric function getDuration(){
        var clip = getClip();
        return clip.getMicrosecondLength();
    }
    
    /**
    * Resets the audio stream
    */
    private CFWavPlayer function resetAudioStream(){
        // create AudioInputStream object
        try {
            var file = variables.fileReader.init( getFilePath() );
            var audioInputStream = variables.AudioSystem.getAudioInputStream( file );
            setAudioInputStream( audioInputStream );
            loadClip( file );
        } catch( any e ){
            if( e.type == 'javax.sound.sampled.UnsupportedAudioFileException' ){
                throw( "unsupported audio format: '" & getFilePath() & "'" );
            }
            throw( e );
        }
        return this;
    }

    /**
    * Loads the audio system clip and opens the input stream
    */
    private CFWavPlayer function loadClip(){
        // open audioInputStream to the clip
        var clip = variables.AudioSystem.getClip();
        clip.open( getAudioInputStream() );
        // create clip reference
        setClip( clip );
        return this;
    }

}