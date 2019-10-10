# CFWavPlayer - A CFML wrapper to load and play wav audio files within your application


# Create a new player


```
<cfscript>
    WavBuilder = new com.coldfumonkeh.CFWavPlayer.WavBuilder();

    player1 = WavBuilder
        .new()
        .file( './wav_audio.wav' )
        .play();
</cfscript>
```

This will create a new instance of the WavPlayer object, load in a file and play it to the end.


```
player1 = WavBuilder
    .new()
    .file( './wav_audio.wav' )
    .play()
    .wait( 5000 )
    .stop();
```

You can choose to run an action on the CFWavPlayer instance at a given duration, using the `wait()` method. This is essentially a helper shortcut method to the CFML `sleep()` function.

So, in the above example, we load a file, start playing it, and five seconds into it we stop.

We could use the `wait()` method to do other things:

```
player1 = WavBuilder
    .new()
    .file( './wav_audio.wav' )
    .play()
    .wait( 5000 )
    .pause()
    .wait( 1500 )
    .resume();
```

here we play the loaded wav file, wait five seconds, pause it, wait another 1.5 seconds, then resume playing from where we ledt off.

## Jumping the playhead

You can use the `jumpTo()` method to move the virtual playhead to a given point in the track and then start playing from there:

```
player1 = WavBuilder
    .new()
    .file( './wav_audio.wav' )
    .jumpTo( 250000000 )
    .play();
```

## Looping

You can loop an audio file endlessly, should you wish too:

```
player1 = WavBuilder
    .new()
    .file( './wav_audio.wav' )
    .loop();
```

** Note that with the `loop()` method added to the chain you do not need to call the `play()` method.

To stop the loop, you would then just need to call:

```
player1.stop();
```

In this looping example, we can loop over the audi file, which is roughly ten seconds long.
After 2.5 loops, we can stop it:

```
player1 = WavBuilder
    .new()
    .file( './wav_audio.wav' )
    .loop()
    .wait( 250000 )
    .stop();
```

## Multiple sounds at once!

You can use CFWavPlayer to play multiple sounds at once through the browser.

Before we play the audio in `player`, we can get the duration (in microseconds) from the underlying Java Clip instance. We can then convert that duration into milliseconds and pass it into the `wait()` method on `player2`, after which we'll tell it to stop playing.

Running this, both sounds will start and end at the same time, the second looping until the first one finishes.

The parallel play doesn't seem work in Lucee (yet), but I have tested it and it is working on Adobe ColdFusion 2018.

```
WavBuilder = new com.coldfumonkeh.CFWavPlayer.WavBuilder();

// Plays sounds in parallel
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
```

## Debugging (kinda)

You can debug (in a way) by also dumping out the current status of the CFWavPlayer instance, as well as the current frame of the audio playhead:

```
player1 = WavBuilder
    .new()
    .file( './wav_audio.wav' )
    .play();

writedump( player1.getStatus() );
writedump( player1.getCurrentFrame() );

player1.pause();

writedump( player1.getStatus() );
writedump( player1.getCurrentFrame() );

player1.stop();

writedump( player1.getStatus() );
writedump( player1.getCurrentFrame() );

player1.restart();

writedump( player1.getStatus() );
writedump( player1.getCurrentFrame() );
```

