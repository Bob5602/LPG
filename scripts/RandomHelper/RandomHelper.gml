/// This library ported from HTML5 runner.

globalvar g_WELL512_state, g_WELL512_RndIndex, g_WELL512_nRandSeed, g_WELL512_nRandomPoly;

g_WELL512_state = []; 							// initialize state to random bits
g_WELL512_RndIndex = 0;							// reset anyway
g_WELL512_nRandSeed = WELL512_InitRandom(0);	// init should also reset this to 0
g_WELL512_nRandomPoly = 0xDA442D24;


// #############################################################################################
/// Function:<summary>
///          	Init the random number system to "something"
///          </summary>
///
/// Out:	<returns>
///				0 (for global initialisation)
///			</returns>
// #############################################################################################
function WELL512_InitRandom( _seed ) {
	var s = _seed;
	for (var i = 0; i < 16; i++)
	{
		s = (((s * 214013 + 2531011) & 0xffffffff) >> 16) | 0;
		g_WELL512_state[i] = ~ ~s;
	}
	g_WELL512_RndIndex = 0;
	g_WELL512_nRandSeed = _seed;
	return g_WELL512_nRandSeed;
}


// #############################################################################################
/// Function:<summary>
///          	Returns a random number between 0 and 1
///             PRNG from http://www.lomont.org/Math/Papers/2008/Lomont_PRNG_2008.pdf
///             other reading http://stackoverflow.com/questions/1046714/what-is-a-good-random-number-generator-for-a-game
///          </summary>
// #############################################################################################
function WELL512_rand()
{
	var a, b, c, d;
    a = g_WELL512_state[g_WELL512_RndIndex];
    c = g_WELL512_state[(g_WELL512_RndIndex + 13) & 15];
    b = (a^c^(a<<16)^(c<<15)) & 0xffffffff;
    c = g_WELL512_state[(g_WELL512_RndIndex + 9) & 15];
    c ^= (c>>11);
    a = g_WELL512_state[g_WELL512_RndIndex] = b ^ c;
    d = (a ^ ((a << 5) & g_WELL512_nRandomPoly)) & 0xffffffff;
    g_WELL512_RndIndex = (g_WELL512_RndIndex + 15) & 15;
    a = g_WELL512_state[g_WELL512_RndIndex];
    g_WELL512_state[g_WELL512_RndIndex] = (a ^ b ^ d ^ (a << 2) ^ (b << 18) ^ (c << 28)) & 0xffffffff;
    return ((g_WELL512_state[g_WELL512_RndIndex] & 0x7fffffff) / 2147483647.0); 		// between 0 and 1
}


// #############################################################################################
/// Function:<summary>
///          	Returns a random real number between 0 and x. The number is always smaller than x.
///          </summary>
///
/// In:		<param name="_v"></param>
/// Out:	<returns>
///				
///			</returns>
// #############################################################################################
function WELL512_random( _v )
{
	var _r = WELL512_rand();
	return _r * real(_v);
}
#macro random WELL512_random


// #############################################################################################
/// Function:<summary>
///          	Returns a random integer number between 0 and x (inclusive when x is an integer).
///          </summary>
///
/// In:		<param name="_v"></param>
/// Out:	<returns>
///				
///			</returns>
// #############################################################################################
function WELL512_irandom( _v ) 
{
    var sgn = _v < 0 ? -1 : 1;
    var r = WELL512_rand() * (_v + sgn);
	WELL512_rand(); // WHY?
	return  ~~r;
}
#macro irandom WELL512_irandom


// #############################################################################################
/// Function:<summary>
///          	Returns a random real number between x1 (inclusive) and x2 (exclusive).
///          </summary>
///
/// In:		<param name="val0"></param>
///			<param name="val1"></param>
/// Out:	<returns>
///				
///			</returns>
// #############################################################################################
function WELL512_random_range( _val0, _val1 ) {

    _val0 = real(_val0);
    _val1 = real(_val1);

    if (_val0 == _val1) {
        return _val0;
    }

    var lower, higher;
    if (_val0 > _val1) {
        lower = _val1;
        higher = _val0;
    }
    else {
        lower = _val0;
        higher = _val1;
    }

	var rp1 = WELL512_rand();
	var result = lower + (rp1 * (higher - lower));

	WELL512_rand(); // WHY?
	return result;
}
#macro random_range WELL512_random_range


// #############################################################################################
/// Function:<summary>
///          	Sets the seed (an integer) that is used for the random number generation. 
///             Can be used to repeat the same random sequence. (Note though that also some 
///             actions and the system itself uses random numbers.)
///          </summary>
///
/// In:		<param name="_val"></param>
/// Out:	<returns>
///				
///			</returns>
// #############################################################################################
function WELL512_random_set_seed( _val )
{
    WELL512_InitRandom(0x7fffffff & _val);
}
#macro random_set_seed WELL512_random_set_seed


// #############################################################################################
/// Function:<summary>
///          	Sets the seed to a random number
///          </summary>
// #############################################################################################
function WELL512_randomize() 
{
	var d =  date_current_datetime();
	var t = date_get_second(d) * 1000;
	t = (t & 0xffffffff) ^ ((t >> 16) & 0xffff) ^ ((t << 16) & 0xffff0000);
    return WELL512_InitRandom( t );
}
#macro randomize WELL512_randomize
#macro randomise WELL512_randomize


// #############################################################################################
/// Function:<summary>
///          	Returns a random real number between val0 (inclusive) and val1 (inclusive). 
///             Both val0 and val1 must be integer values (otherwise they are rounded down).
///          </summary>
///
/// In:		<param name="val0"></param>
///			<param name="val1"></param>
/// Out:	<returns>
///				
///			</returns>
// #############################################################################################
function WELL512_irandom_range( _val0, _val1 ) 
{
    _val0 &= 0xffffffff;
    _val1 &= 0xffffffff;

    var lower, higher;
    if (_val0 > _val1) {
        lower = _val1;
        higher = _val0;
    }
    else {
        lower = _val0;
        higher = _val1;
    }

    // '| 0' effectively casts to an integer
    var x1 = lower | 0;
    var x2 = higher | 0;
    var result = x1 + ~~WELL512_random(x2 - x1 + 1);

    return result;
}
#macro irandom_range WELL512_irandom_range


// #############################################################################################
/// Function:<summary>
///          	Returns the current seed.
///          </summary>
///
/// Out:	<returns>
///				
///			</returns>
// #############################################################################################
function WELL512_random_get_seed() 
{
    return g_WELL512_nRandSeed;
}
#macro random_get_seed WELL512_random_get_seed


// #############################################################################################
/// Function:<summary>
///             Returns one of the arguments choosen randomly.
///          </summary>
///
/// In:		 <param name="paramlist">     variable length arguments    </param>
/// Out:	 <returns>
///				One of the arguments chosen at random.
///			 </returns>
// #############################################################################################
function WELL512_choose()
{
    if (argument_count == 0) return 0;
    var index = floor(WELL512_random(argument_count));
    return argument[index];
}
#macro choose WELL512_choose
