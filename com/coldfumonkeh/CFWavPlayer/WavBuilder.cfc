/**
* Name: CFWavPlayer.cfc
* Author: Matt Gifford (https://www.monkehworks.com)
* Date: 10th October 2019
* This is a static factory class used to build new CFWavPlayer instances.
*/
component singleton{

    /**
     * Constructor
     */
    WavBuilder function init(){
        return this;
    }

    /**
	 * Construct a new CFWavPlayer instance
	 */
    CFWavPlayer function new(){
        return new CFWavPlayer();
    }

}