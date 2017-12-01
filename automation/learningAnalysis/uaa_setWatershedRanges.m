function uaa_setWatershedRanges
global uaa
ranges=uaa.learningAnalysis.ranges;

uaa.learningAnalysis.rangeCells={...
    [ranges.tfdre1:ranges.tfdre2], 'uaa.settings.watershed.tfd';
    [ranges.bw3iore1:ranges.bw3iore2], 'uaa.settings.watershed.bw3io';
    [ranges.bw4aore1:ranges.bw4aore2], 'uaa.settings.watershed.bw4ao';           
    [ranges.mslre1:ranges.mslre2], 'uaa.settings.watershed.msl';            
    [ranges.bw5aore1:ranges.bw5aore2], 'uaa.settings.watershed.bw5ao';            
    [ranges.bw6imcre1:ranges.bw6imcre2], 'uaa.settings.watershed.bw6imc';           
    [ranges.bw7aore1:ranges.bw7aore2], 'uaa.settings.watershed.bw7ao';           
    [ranges.imexre1:ranges.imexre2], 'uaa.settings.watershed.imex';           
    [ranges.micre1:ranges.micre2], 'uaa.settings.watershed.mic';           
    [ranges.mbwaore1:ranges.mbwaore2], 'uaa.settings.watershed.mbwao';           
    [ranges.gbre1:ranges.gbre2], 'uaa.settings.watershed.gbr';
    };
