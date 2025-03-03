
*********************************************************************
*  Title:         ChPRS annual report generation (Step 1 of 3)         
*                                                                    
*  Description:   Importing data entries from Redcap, formatting variables, 
*				  checking for missing values, exporting as dataset
*                     
*------------------------------------------------------------------- 
*
*  Input:         CSV file 
*
*  Output:        SAS dataset, PDF of missing data checks
*
*  Created:       01-31-2025
*
*  Last updated:  02-28-2025
*                                             
********************************************************************;

options orientation=landscape;
/* For %let statements, edit after = */ 

/* Year of report */
%let year = 2022; 

/* Path to CSV file */
%let csv_file = '/home/u63543840/work/ChPRSChemicalPrepare-2022Report_DATA_2025-02-28_2124.csv';

/* Path for library name */
libname c '~/work';

/* Path for PDF file */
ods pdf file="~/work/&year.report_step1.PDF";

ods noproctitle;

title1 "&year. report step 1 of 3";
title2 "Importing data entries from Redcap, formatting variables, checking for missing values";
ods exclude EngineHost;
proc contents;
run;
title;

OPTIONS nofmterr;

proc format;
	value county_ 
	1='Alamance' 2='Alexander' 
		3='Alleghany' 4='Anson' 
		5='Ashe' 6='Avery' 
		7='Beaufort' 8='Bertie' 
		9='Bladen' 10='Brunswick' 
		11='Buncombe' 12='Burke' 
		13='Cabarrus' 14='Caldwell' 
		15='Camden' 16='Carteret' 
		17='Caswell' 18='Catawba' 
		19='Chatham' 20='Cherokee' 
		21='Chowan' 22='Clay' 
		23='Cleveland' 24='Columbus' 
		25='Craven' 26='Cumberland' 
		27='Currituck' 28='Dare' 
		29='Davidson' 30='Davie' 
		31='Duplin' 32='Durham' 
		33='Edgecombe' 34='Forsyth' 
		35='Franklin' 36='Gaston' 
		37='Gates' 38='Graham' 
		39='Granville' 40='Greene' 
		41='Guilford' 42='Halifax' 
		43='Harnett' 44='Haywood' 
		45='Henderson' 46='Hertford' 
		47='Hoke' 48='Hyde' 
		49='Iredell' 50='Jackson' 
		51='Johnston' 52='Jones' 
		53='Lee' 54='Lenoir' 
		55='Lincoln' 56='McDowell' 
		57='Macon' 58='Madison' 
		59='Martin' 60='Mecklenburg' 
		61='Mitchell' 62='Montgomery' 
		63='Moore' 64='Nash' 
		65='New Hanover' 66='Northampton' 
		67='Onslow' 68='Orange' 
		69='Pamlico' 70='Pasquotank' 
		71='Pender' 72='Perquimans' 
		73='Person' 74='Pitt' 
		75='Polk' 76='Randolph' 
		77='Richmond' 78='Robeson' 
		79='Rockingham' 80='Rowan' 
		81='Rutherford' 82='Sampson' 
		83='Scotland' 84='Stanly' 
		85='Stokes' 86='Surry' 
		87='Swain' 88='Transylvania' 
		89='Tyrrell' 90='Union' 
		91='Vance' 92='Wake' 
		93='Warren' 94='Washington' 
		95='Watauga' 96='Wayne' 
		97='Wilkes' 98='Wilson' 
		99='Yadkin' 100='Yancey';
	value relstyp_ 1='Spill (liquid or solid)' 2='Volatilization/aerosolized (vapor)' 
		3='Radiation' 4='Explosion' 
		5='Fire' 6='Reaction' 
		7='Mixture';
	value sub_typ_ 1='Chemical' 2='Radiological' 
		3='Medical' 4='Biological';
	value location_ 1='Private residence or private vehicle' 2='Transportation' 
		3='Fixed Facility' 4='Other';
	value sub1_ 1='1- Pentene' 2='1,1-Dimethyl hydrazine' 
		3='1,2-Dibromo-3-chloropropane' 4='1,2-Dibromoethane' 
		5='1,2-Ethanediamine' 6='1,3 Butadiene' 
		7='1,3-Bis(2-chloroethylthio)-npropane' 8='1,3-Butadiene' 
		9='1,3-Pentadiene' 10='1,4,5,6,7,8,8-Heptachloro-3a,4,7,7a-tetrahydro-4,7-methano-1H-indene' 
		11='1,4:5,8-Dimethanonaphthalene, 1,2,3,4,10,10-hexachloro-1,4,4a,5,8,8a-hexahydro(1.alpha.,4.alpha.,4a.beta.,5.alpha.,8.alpha.,8a.beta.)­' 12='1,4-Dichloro-2-butene' 
		13='1,5-Bis(2-chloroethylthio)-nbutane' 14='1,5-Bis(2-chloroethylthio)-npentane' 
		15='1-Butene' 16='1-Chloropropylene' 
		17='1H-Tetrazole' 18='2,2''-Bioxirane' 
		19='2,2-Dimethyl-1,3-benzodioxol-4-ol methylcarbamate' 20='2,2-Dimethylpropane' 
		21='2,3,7,8-Tetrachlorodibenzo-p-dioxin (TCDD)' 22='2,4-Dithiobiuret' 
		23='2-Acetylaminofluorene' 24='2-Butenal' 
		25='2-Butenal, (e)­' 26='2-Butene' 
		27='2-Butene, 1,4-dichloro' 28='2-Butene-cis' 
		29='2-Butene-trans' 30='2-Chloro-N-(2-chloroethyl)-N-methylethanamine' 
		31='2-Chloropropylene' 32='2-Methyl-1-butene' 
		33='2-Methyllactonitrile' 34='2-Methylpropene' 
		35='2-Pentene, (E)­' 36='2-Pentene, (Z)­' 
		37='2-Propen-1-amine' 38='2-Propen-1-ol' 
		39='2-Propenal' 40='2-Propenenitrile' 
		41='2-Propenenitrile, 2-methyl2-Propenoyl' 42='3,3''-Dichlorobenzidine' 
		43='3-Chloropropionitrile' 44='3-Methyl-1-butene' 
		45='4,6-Dinitro-o-cresol' 46='4,7-Methanoindan, 1,2,3,4,5,6,7,8,8-octachloro-2,3,3a,4,7,7a-hexahydro4-Aminopyridine' 
		47='4-Aminobiphenyl' 48='5-(Aminomethyl)-3-isoxazolol' 
		49='5-Fluorouracil' 50='7,12-Dimethylbenz[a]anthracene' 
		51='Acetaldehyde' 52='Acetic acid ethenyl ester' 
		53='Acetone' 54='Acetone cyanohydrin' 
		55='Acetone thiosemicarbazide' 56='Acetyl bromide' 
		57='Acetyl chloride' 58='Acetyl iodide' 
		59='Acetylene' 60='Acrolein' 
		61='Acrylamide' 62='Acrylonitrile' 
		63='Acrylyl chloride' 64='Adiponitrile' 
		65='Aldicarb' 66='Aldicarb sulfone' 
		67='Aldrin' 68='Allyl alcohol' 
		69='Allylamine' 70='Allyltrichlorosilane, stabilized' 
		71='alpha - Endosulfan' 72='Aluminum (powder)' 
		73='Aluminum bromide, anhydrous' 74='Aluminum chloride, anhydrous' 
		75='Aluminum phosphide' 76='Aminopterin' 
		77='Amiton' 78='Amiton oxalate' 
		79='Ammonia' 80='Ammonia (anhydrous)' 
		81='Ammonium nitrate, [with more than 0.2 percent combustible substances, including any' 82='Ammonium nitrate, solid [nitrogen concentration of 23% nitrogen or greater]' 
		83='Ammonium perchlorate' 84='Ammonium picrate' 
		85='Amphetamine' 86='Amyltrichlorosilane' 
		87='Anesthetics (all types)' 88='Aniline' 
		89='Aniline, 2,4,6-trimethylAntimony' 90='Antimycin A' 
		91='ANTU' 92='Any of the various naphtha, such as Ligroin (light naphtha)' 
		93='Any other petroleum derivative that has not been refined to the point of being a single substance (e.g., crude oil)' 94='Aroclor 1016' 
		95='Aroclor 1221' 96='Aroclor 1232' 
		97='Aroclor 1242' 98='Aroclor 1248' 
		99='Aroclor 1254' 100='Aroclor 1260' 
		101='Arsenic' 102='Arsenic acid' 
		103='Arsenic disulfide' 104='Arsenic pentoxide' 
		105='Arsenic trioxide' 106='Arsenic trisulfide' 
		107='Arsenous oxide' 108='Arsenous trichloride' 
		109='Arsine' 110='Asbestos (friable)' 
		111='Asphalt, petroleum coke, or other heavy or high-carbon petroleum cuts.' 112='Atrazine' 
		113='Azaserine' 114='Azinphos-ethyl' 
		115='Azinphos-methyl' 116='Aziridine' 
		117='Aziridine, 2-methyl' 118='Barban' 
		119='Barium azide' 120='Battery acid (see Step 2 for additional guidance)' 
		121='Bendiocarb' 122='Bendiocarb phenol' 
		123='Benomyl' 124='Benzal chloride' 
		125='Benzenamine, 3-(trifluoromethyl)­' 126='Benzene' 
		127='Benzene, 1-(chloromethyl)-4-nitro-' 128='Benzene, 1,1''-(2,2,2-trichloroethylidene)bis [4-methoxy-' 
		129='Benzene, 1,3-diisocyanato-2-methyl-' 130='Benzene, 2,4-diisocyanato-1-methyl-' 
		131='Benzenearsonic acid' 132='Benzenethiol' 
		133='Benzidine' 134='Benzimidazole, 4,5-dichloro-2-(trifluoromethyl)­' 
		135='Benzo[a]pyrene' 136='Benzo[b]fluoranthene' 
		137='Benzoic trichloride' 138='Benzotrichloride' 
		139='Benzyl chloride' 140='Benzyl cyanide' 
		141='Beryllium chloride' 142='Beryllium fluoride' 
		143='Beryllium nitrate' 144='Beryllium nitrate' 
		145='beta - Endosulfan' 146='beta-BHC' 
		147='beta-Propiolactone' 148='Bicyclo[2.2.1]heptane-2-carbonitrile, 5-chloro-6-((((methylamino)carbonyl)oxy)imino)-,(1­alpha,2-beta,4-alpha,5-alpha,6E))­' 
		149='Bis(2-chloroethyl) ether' 150='Bis(2-chloroethylthio)methane' 
		151='Bis(2-chloroethylthiomethyl)ether' 152='Bis(chloromethyl) ether' 
		153='Bis(chloromethyl) ketone' 154='Bitoscanate' 
		155='Borane, trichloroBorane,' 156='Boron trichloride' 
		157='Boron trifluoride' 158='Boron trifluoride compound with methyl ether (1:1)' 
		159='Boron, trifluoro[oxybis[methane]]-, (T-4)-' 160='Bromadiolone' 
		161='Bromine' 162='Bromine chloride' 
		163='Bromine pentafluoride' 164='Bromine trifluoride' 
		165='Bromomethane' 166='Bromotrifluorethylene' 
		167='Butane' 168='Butane' 
		169='Butene' 170='Butyltrichlorosilane' 
		171='Cacodylic acid' 172='Cadmium oxide' 
		173='Cadmium stearate' 174='Calcium arsenate' 
		175='Calcium arsenite' 176='Calcium hydrosulfite' 
		177='Calcium phosphide' 178='Camphechlor' 
		179='Camphene, octachloro' 180='Cantharidin' 
		181='Carbachol chloride' 182='Carbamic acid, methyl-, O-(((2,4-dimethyl-1,3-dithiolan-2-yl)methylene)amino)-' 
		183='Carbamothioic acid, dipropyl-, S-(phenylmethyl) ester' 184='Carbendazim' 
		185='Carbofuran' 186='Carbofuran phenol' 
		187='Carbon disulfide' 188='Carbon Monoxide (≤ 35ppm known concentration; see Step 2 for additional guidance)' 
		189='Carbon oxysulfide' 190='Carbonic dichloride' 
		191='Carbonochloridic acid, 1-methylethyl ester' 192='Carbonochloridic acid, methylester' 
		193='Carbonochloridic acid, propylester' 194='Carbonyl fluoride' 
		195='Carbonyl sulfide' 196='Carbophenothion' 
		197='Carbosulfan' 198='Chlordane' 
		199='Chlorfenvinfos' 200='chloride' 
		201='Chlorine' 202='Chlorine dioxide' 
		203='Chlormephos' 204='Chlormequat chloride' 
		205='Chloroacetic acid' 206='Chloroethanol' 
		207='Chloroethyl chloroformate' 208='Chloroform' 
		209='Chloromethyl ether' 210='Chloromethyl methyl ether' 
		211='Chlorophacinone' 212='Chlorosarin' 
		213='Chlorosoman' 214='Chlorosulfonic acid' 
		215='Chloroxuron' 216='Chlorpyrifos' 
		217='Chlorthiophos' 218='Chromic chloride' 
		219='Chromium oxychloride' 220='Cobalt carbonyl' 
		221='Cobalt, ((2,2''-(1,2-ethanediylbis(nitrilomethylidyne))bis(6-fluorophenylato))(2-)­N,N'',O,O'')-' 222='Coke Oven Emissions' 
		223='Colchicine' 224='Coumaphos' 
		225='Coumatetralyl' 226='Creosote' 
		227='Crimidine' 228='Crotonaldehyde' 
		229='Crotonaldehyde, (E)-' 230='Cupric acetoarsenite' 
		231='Cyanogen' 232='Cyanogen bromide' 
		233='Cyanogen chloride' 234='Cyanogen iodide' 
		235='Cyanophos' 236='Cyanuric fluoride' 
		237='Cyclohexanamine' 238='Cyclohexane' 
		239='Cyclohexane, 1,2,3,4,5,6-hexachloro­,(1.alpha.,2.alpha.,3.beta.,4.alpha.,5.alpha.,6.beta.)-' 240='Cycloheximide' 
		241='Cyclohexylamine' 242='Cyclohexyltrichlorosilane' 
		243='Cyclopropane' 244='DBCP' 
		245='DDD' 246='DDE' 
		247='DDT' 248='Decaborane(14)' 
		249='delta-BHC' 250='Demeton' 
		251='Demeton-S-methyl' 252='DF' 
		253='Dialifor' 254='Diazinon' 
		255='Diazodinitrophenol' 256='Dibenz[a,h]anthracene' 
		257='Diborane' 258='Diborane(6)' 
		259='Dichlone' 260='Dichloroethyl ether' 
		261='Dichloromethyl ether' 262='Dichloromethylphenylsilane' 
		263='Dichlorophenylarsine' 264='Dichlorosilane' 
		265='Dichlorvos' 266='Dicrotophos' 
		267='Dieldrin' 268='Diepoxybutane' 
		269='Diesel fuels' 270='Diethyl chlorophosphate' 
		271='Diethyl methylphosphonite' 272='Diethylarsine' 
		273='Diethyldichlorosilane' 274='Diethyleneglycol dinitrate' 
		275='Diethylstilbestrol' 276='Difluoroethane' 
		277='Digitoxin' 278='Diglycidyl ether' 
		279='Digoxin' 280='Diisopropylfluorophosphate' 
		281='Dimefox' 282='Dimethoate' 
		283='Dimethyl chlorothiophosphate' 284='Dimethyl phosphorochloridothioate' 
		285='Dimethyl sulfate' 286='Dimethylamine' 
		287='Dimethylcarbamyl chloride' 288='Dimethyldichlorosilane' 
		289='Dimethyldichlorosilane' 290='Dimethylhydrazine' 
		291='Dimethyl-p-phenylenediamine' 292='Dimetilan' 
		293='Dingu' 294='Dinitrobutyl phenol' 
		295='Dinitrocresol' 296='Dinitrogen tetroxide' 
		297='Dinitrophenol' 298='Dinitroresorcinol' 
		299='Dinoseb' 300='Dinoterb' 
		301='Dioxathion' 302='Diphacinone' 
		303='Diphenyldichlorosilane' 304='Diphosphoramide, octamethyl-' 
		305='Dipicryl sulfide' 306='Dipicrylamine [or] Hexyl' 
		307='Disulfoton' 308='Dithiazanine iodide' 
		309='Dithiobiuret' 310='Dodecyltrichlorosilane' 
		311='Emetine, dihydrochloride' 312='Endosulfan' 
		313='Endosulfan sulfate' 314='Endothion' 
		315='Endrin' 316='Endrin aldehyde' 
		317='Epichlorohydrin' 318='EPN' 
		319='Epoxies (all types)' 320='Ergocalciferol' 
		321='Ergotamine tartrate' 322='Ethane' 
		323='Ethane, 1,1''-thiobis[2-chloro-' 324='Ethaneperoxoic acid' 
		325='Ethanesulfonyl chloride, 2-chloro-' 326='Ethanimidothioic acid, 2-(dimethylamino)-N-hydroxy-2-oxo-, methyl ester' 
		327='Ethanimidothioic acid, N-[[methylamino)carbonyl]' 328='Ethanol, 1,2-dichloro-, acetate' 
		329='Ethanol, 2,2''-oxybis-, dicarbamate' 330='Ethanol, ethyl alcohol' 
		331='Ethene, chloro-' 332='Ethion' 
		333='Ethoprop' 334='Ethoprophos' 
		335='Ethyl acetylene' 336='Ethyl chloride' 
		337='Ethyl cyanide' 338='Ethyl ether' 
		339='Ethyl mercaptan' 340='Ethyl methanesulfonate' 
		341='Ethyl nitrite' 342='Ethyl phosphonyl difluoride' 
		343='Ethylamine' 344='Ethylbis(2-chloroethyl)amine' 
		345='Ethyldiethanolamine' 346='Ethylene' 
		347='Ethylene dibromide' 348='Ethylene fluorohydrin' 
		349='Ethylene oxide' 350='Ethylenediamine' 
		351='Ethyleneimine' 352='Ethylphosphonothioic dichloride' 
		353='Ethylthiocyanate' 354='Ethyltrichlorosilane' 
		355='Fenamiphos' 356='Fensulfothion' 
		357='Fluenetil' 358='Fluorine' 
		359='Fluoroacetamide' 360='Fluoroacetic acid' 
		361='Fluoroacetic acid, sodium salt' 362='Fluoroacetyl chloride' 
		363='Fluorosilicic acid' 364='Fluorosulfonic acid' 
		365='Fluorouracil' 366='Fonofos' 
		367='Formaldehyde' 368='Formaldehyde (solution)' 
		369='Formaldehyde cyanohydrin' 370='Formetanate hydrochloride' 
		371='Formothion' 372='Formparanate' 
		373='Fosthietan' 374='Freons (minimum 100 pounds)' 
		375='Fuberidazole' 376='Fuel oils/Heating oils' 
		377='Furan' 378='Gallium trichloride' 
		379='Gas oil' 380='Gasoline/Gas' 
		381='Germane' 382='Germanium tetrafluoride' 
		383='Guanyl nitrosaminoguanylidene hydrazine' 384='Guthion' 
		385='Heptachlor' 386='Heptachlor epoxide' 
		387='Hexachloro-1,3-butadiene' 388='Hexachlorobutadiene' 
		389='Hexachlorocyclohexane (gamma isomer)' 390='Hexachlorocyclopentadiene' 
		391='Hexaethyl tetraphosphate and compressed gas mixtures' 392='Hexafluoroacetone' 
		393='Hexafluorosilicic acid' 394='Hexamethylenediamine, N,N''-dibutyl-' 
		395='Hexamethylphosphoramide' 396='Hexanitrostilbene' 
		397='Hexolite' 398='Hexyltrichlorosilane' 
		399='HMX' 400='HN1 (nitrogen mustard-1)' 
		401='HN2 (nitrogen mustard-2)' 402='HN3 (nitrogen mustard-3)' 
		403='Hydrazine' 404='Hydrazine, 1,1-dimethyl-' 
		405='Hydrazine, 1,2-dimethyl-' 406='Hydrazine, methyl-' 
		407='Hydrocyanic acid' 408='Hydrofluoric acid' 
		409='Hydrofluoric acid (conc. 50% or greater)' 410='Hydrofluorosilicic acid' 
		411='Hydrogen' 412='Hydrogen bromide' 
		413='Hydrogen chloride (anhydrous)' 414='Hydrogen chloride (gas only)' 
		415='Hydrogen cyanide' 416='Hydrogen fluoride' 
		417='Hydrogen fluoride (anhydrous)' 418='Hydrogen peroxide (Conc.> 52%)' 
		419='Hydrogen peroxide (concentration of at least 35%)' 420='Hydrogen selenide' 
		421='Hydrogen sulfide' 422='Hydroquinone' 
		423='Iodine pentafluoride' 424='Iron carbonyl (Fe(CO)5), (TB-5-11)­' 
		425='Iron, pentacarbonyl-' 426='Isobenzan' 
		427='Isobutane' 428='Isobutyronitrile' 
		429='Isocyanates and diisocyanatos (all types)' 430='Isocyanic acid, 3,4-dichlorophenyl ester' 
		431='Isodrin' 432='Isofluorphate' 
		433='Isopentane' 434='Isophorone diisocyanate' 
		435='Isoprene' 436='Isopropyl chloride' 
		437='Isopropyl chloroformate' 438='Isopropylamine' 
		439='Isopropylmethylpyrazolyl dimethylcarbamate' 440='Isopropylphosphonothioic dichloride' 
		441='Isopropylphosphonyl difluoride' 442='Isothiocyanatomethane' 
		443='Jet fuels (JP-5, JP-7, etc. These are similar to kerosene.)' 444='Kepone' 
		445='Kerosene/kerosene' 446='Lactonitrile' 
		447='Lead arsenate' 448='Lead azide' 
		449='Lead styphnate' 450='Leptophos' 
		451='Lewisite' 452='Lewisite 1' 
		453='Lewisite 2' 454='Lewisite 3' 
		455='Lindane' 456='Lithium amide' 
		457='Lithium hydride' 458='Lithium nitride' 
		459='LPG (liquefied petroleum gas) a mixture of butane (62%) and propane (38%)' 460='Lubricating oils, common grease, or hydraulic fluids that are petroleum based' 
		461='Magnesium (powder)' 462='Magnesium diamide' 
		463='Magnesium phosphide' 464='Malononitrile' 
		465='Manganese, bis(dimethylcarbamodithioato-S,S'')-' 466='Manganese, tricarbonyl methylcyclopentadienyl' 
		467='MDEA' 468='Mechlorethamine' 
		469='Medical waste consisting of hazardous substances or radioactive materials' 470='Melphalan' 
		471='Mephosfolan' 472='Mercaptodimethur' 
		473='Mercuric acetate' 474='Mercuric chloride' 
		475='Mercuric cyanide' 476='Mercuric oxide' 
		477='Mercury' 478='Mercury fulminate' 
		479='Methacrolein diacetate' 480='Methacrylic anhydride' 
		481='Methacrylonitrile' 482='Methacryloyl chloride' 
		483='Methacryloyloxyethyl isocyanate' 484='Methamidophos' 
		485='Methamphetamine Production chemicals' 486='Methanamine, N-methyl-N-nitroso-' 
		487='Methane' 488='Methane, chloromethoxy-' 
		489='Methane, isocyanato-' 490='Methane, oxybis[chloro-' 
		491='Methane, tetranitro-' 492='Methane, trichloro-' 
		493='Methanesulfenyl chloride, trichloro-' 494='Methanesulfonyl fluoride' 
		495='Methanethiol' 496='Methanol' 
		497='Methidathion' 498='Methiocarb' 
		499='Methomyl' 500='Methoxychlor' 
		501='Methoxyethylmercuric acetate' 502='Methyl 2-chloroacrylate' 
		503='Methyl bromide' 504='Methyl chloride' 
		505='Methyl chlorocarbonate' 506='Methyl chloroformate' 
		507='Methyl ether' 508='Methyl formate' 
		509='Methyl hydrazine' 510='Methyl isocyanate' 
		511='Methyl isothiocyanate' 512='Methyl mercaptan' 
		513='Methyl parathion' 514='Methyl phenkapton' 
		515='Methyl phosphonic dichloride' 516='Methyl thiocyanate' 
		517='Methyl vinyl ketone' 518='Methylamine' 
		519='Methylchlorosilane' 520='Methyldichlorosilane' 
		521='Methylmercuric dicyanamide' 522='Methylphenyldichlorosilane' 
		523='Methylphosphonothioic dichloride' 524='Methyltrichlorosilane' 
		525='Metolcarb' 526='Mevinphos' 
		527='Mexacarbate' 528='Mineral oil or Mineral spirits' 
		529='Mitomycin C' 530='Monocrotophos' 
		531='Muscimol' 532='Mustard gas' 
		533='N,N-(2-diethylamino)ethanethiol' 534='N,N-(2-diisopropylamino)ethanethiol N,N-diisopropyl-(beta)-aminoethane thiol' 
		535='N,N-(2-dimethylamino)ethanethiol' 536='N,N-(2-dipropylamino)ethanethiol' 
		537='N,N-Diethyl phosphoramidic dichloride' 538='N,N-Diisopropyl phosphoramidic dichloride' 
		539='N,N-Dimethyl phosphoramidic dichloride Dimethylphosphoramidodichloridate' 540='N,N-Dipropyl phosphoramidic dichloride' 
		541='Natural gas' 542='Nickel carbonyl' 
		543='Nicotine' 544='Nicotine sulfate' 
		545='Nitric acid' 546='Nitric acid (conc 80% or greater)' 
		547='Nitric oxide' 548='Nitrobenzene' 
		549='Nitrocellulose' 550='Nitrocyclohexane' 
		551='Nitrogen dioxide' 552='Nitrogen mustard' 
		553='Nitrogen mustard hydrochloride' 554='Nitrogen oxide (NO)' 
		555='Nitrogen trioxide' 556='Nitroglycerine' 
		557='Nitromannite' 558='Nitromethane' 
		559='Nitrosodimethylamine' 560='Nitrostarch' 
		561='Nitrosyl chloride' 562='Nitrotriazolone N-Nitrosodimethylamine' 
		563='N-Nitrosodiethanolamine' 564='N-Nitrosodiethylamine' 
		565='N-Nitrosomorpholine' 566='N-Nitroso-N-ethylurea' 
		567='N-Nitroso-N-methylurea' 568='N-Nitroso-N-methylurethane' 
		569='N-Nitrosopyrrolidine' 570='Nonyltrichlorosilane' 
		571='Norbormide' 572='O,O-Diethyl O-pyrazinyl phosphorothioate' 
		573='o,o-Diethyl S-[2-(diethylamino)ethyl] phosphorothiolate' 574='o-Cresol' 
		575='Octadecyltrichlorosilane' 576='Octolite' 
		577='Octonal' 578='Octyltrichlorosilane' 
		579='Oleum (Fuming Sulfuric acid) O-Mustard (T)' 580='organic substance calculated as carbon, to the exclusion of any other added substance]' 
		581='Organorhodium Complex (PMN-82-147)' 582='Ouabain' 
		583='Oxamyl' 584='Oxetane, 3,3-bis(chloromethyl)-' 
		585='Oxirane' 586='Oxirane, (chloromethyl)-' 
		587='Oxirane, methyl-' 588='Oxydisulfoton' 
		589='Oxygen difluoride' 590='Ozone' 
		591='Paint, Paint not otherwise specified (NOS), Paint or Coating (minimum 100 gallons)' 592='Paraquat dichloride' 
		593='Paraquat methosulfate' 594='Parathion' 
		595='Parathion-methyl' 596='Paris green' 
		597='PCBs with a concentration greater than 50ppm (minimum 10 gallons or 1lb)' 598='Pentaborane' 
		599='Pentadecylamine' 600='pentafluoride' 
		601='Pentane' 602='Pentolite' 
		603='Peracetic acid' 604='Perchloromethyl mercaptan' 
		605='Perchloryl fluoride' 606='Perfluoroisobutylene' 
		607='Pesticides (all types)' 608='PETN' 
		609='Petroleum ether' 610='Phenol' 
		611='Phenol, 2,2''-thiobis[4-chloro-6-methyl-' 612='Phenol,3-(1-methylethyl)-, methylcarbamate' 
		613='Phenoxarsine, 10,10''-oxydi-' 614='Phenyl dichloroarsine' 
		615='Phenylhydrazine hydrochloride' 616='Phenylmercuric acetate' 
		617='Phenylmercury acetate' 618='Phenylsilatrane' 
		619='Phenylthiourea' 620='Phenyltrichlorosilane' 
		621='Phorate' 622='Phosacetim' 
		623='Phosfolan' 624='Phosgene' 
		625='Phosphamidon' 626='Phosphine' 
		627='Phosphonothioic acid, methyl-, O-(4-nitrophenyl) O-phenyl ester' 628='Phosphonothioic acid, methyl-, O-ethyl O-(4-(methylthio)phenyl) ester' 
		629='Phosphonothioic acid, methyl-, S-(2-(bis(1-methylethyl)amino)ethyl) O-ethyl ester' 630='Phosphoric acid, 2-dichloroethenyl dimethyl ester' 
		631='Phosphoric acid, dimethyl 4-(methylthio) phenyl ester' 632='Phosphorodithioic acid O-ethyl S,S-dipropyl ester' 
		633='Phosphorothioic acid, O,O-diethyl-O-(4-nitrophenyl) ester' 634='Phosphorothioic acid, O,O-dimethyl-5-(2-(methylthio)ethyl)ester' 
		635='Phosphorous trichloride' 636='Phosphorus' 
		637='Phosphorus (yellow or white)' 638='Phosphorus oxychloride' 
		639='Phosphorus pentabromide' 640='Phosphorus pentachloride' 
		641='Phosphorus pentasulfide' 642='Phosphorus trichloride' 
		643='Phosphoryl chloride' 644='Physostigmine' 
		645='Physostigmine, salicylate (1:1)' 646='Picrite' 
		647='Picrotoxin' 648='Piperidine' 
		649='Pirimifos-ethyl' 650='Plumbane, tetramethyl-' 
		651='Polychlorinated biphenyls (PCBs)' 652='Potassium arsenate' 
		653='Potassium arsenite' 654='Potassium chlorate' 
		655='Potassium cyanide' 656='Potassium hydroxide' 
		657='Potassium nitrate' 658='Potassium perchlorate' 
		659='Potassium permanganate' 660='Potassium phosphide' 
		661='Potassium silver cyanide' 662='Promecarb' 
		663='Propadiene' 664='Propane' 
		665='Propane' 666='Propanenitrile' 
		667='Propanenitrile, 2-methyl-' 668='Propargyl bromide' 
		669='Propham' 670='Propionitrile' 
		671='Propionitrile, 3-chloro-' 672='Propiophenone, 4''-amino' 
		673='Propyl chloroformate' 674='Propyl chloroformate' 
		675='Propylene [1-Propene]' 676='Propylene glycol, ethylene glycol (minimum 50 gallons)' 
		677='Propylene oxide' 678='Propyleneimine' 
		679='Propylphosphonothioic dichloride' 680='Propylphosphonyl difluoride' 
		681='Propyltrichlorosilane' 682='Propyne' 
		683='Prothoate' 684='Pyrene' 
		685='Pyrethrins' 686='Pyridine, 2-methyl-5-vinyl-' 
		687='Pyridine, 3-(1-methyl-2-pyrrolidinyl)-,(S)-' 688='Pyridine, 4-amino-' 
		689='Pyridine, 4-nitro-, 1-oxide' 690='Pyriminil' 
		691='QL' 692='RDX' 
		693='RDX and HMX mixtures' 694='Resins (all types)' 
		695='Salcomine' 696='Sarin' 
		697='Selenious acid' 698='Selenium hexafluoride' 
		699='Selenium oxychloride' 700='Semicarbazide hydrochloride' 
		701='Sesquimustard' 702='Silane' 
		703='Silane, (4-aminobutyl)diethoxymethyl-' 704='Silane, chlorotrimethyl-' 
		705='Silane, dichlorodimethyl-' 706='Silane, trichloromethyl-' 
		707='Silicon tetrachloride' 708='Silicon tetrafluoride' 
		709='Silver cyanide' 710='Silver nitrate' 
		711='Sodium arsenate Sodium arsenite' 712='Sodium azide' 
		713='Sodium azide (Na(N3))' 714='Sodium cacodylate' 
		715='Sodium chlorate' 716='Sodium cyanide (Na(CN))' 
		717='Sodium fluoroacetate' 718='Sodium hydrosulfite' 
		719='Sodium hydroxide' 720='Sodium nitrate' 
		721='Sodium phosphide' 722='Sodium selenate' 
		723='Sodium selenite' 724='Sodium tellurite' 
		725='Soman' 726='Stannane, acetoxytriphenyl-' 
		727='Stibine' 728='Streptozotocin' 
		729='Strontium phosphide' 730='Strychnine' 
		731='Strychnine, sulfate' 732='Styrene' 
		733='Sulfotep' 734='Sulfoxide, 3-chloropropyl octyl' 
		735='Sulfur dioxide' 736='Sulfur dioxide (anhydrous)' 
		737='Sulfur dioxide (anhydrous)' 738='Sulfur fluoride (SF4), (T-4)­' 
		739='Sulfur mustard (Mustard gas(H))' 740='Sulfur tetrafluoride' 
		741='Sulfur tetrafluoride' 742='Sulfur trioxide' 
		743='Sulfuric acid' 744='Sulfuric acid (aerosol forms only)' 
		745='Sulfuryl chloride' 746='Tabun' 
		747='Tellurium hexafluoride' 748='Tellurium hexafluoride' 
		749='TEPP' 750='Terbufos' 
		751='Tetraethyl lead' 752='Tetraethyl pyrophosphate' 
		753='Tetraethyldithiopyrophosphate' 754='Tetraethyltin' 
		755='Tetrafluoroethylene' 756='Tetramethyllead' 
		757='Tetramethylsilane' 758='Tetranitroaniline' 
		759='Tetranitromethane' 760='Tetrazene' 
		761='Thallium chloride TlCl' 762='Thallium sulfate' 
		763='Thallium(I) carbonate' 764='Thallium(I) sulfate' 
		765='Thallous carbonate' 766='Thallous chloride' 
		767='Thallous malonate' 768='Thallous sulfate' 
		769='Thiocarbazide' 770='Thiocyanic acid, methyl ester' 
		771='Thiodicarb' 772='Thiodiglycol' 
		773='Thiofanox' 774='Thiomethanol' 
		775='Thionazin' 776='Thionyl chloride' 
		777='Thiophanate-methyl' 778='Thiophenol' 
		779='Thiosemicarbazide' 780='Thiourea, (2-chlorophenyl)­' 
		781='Thiourea, (2-methylphenyl)­' 782='Thiourea, 1-naphthalenyl-' 
		783='Titanium chloride (TiCl4) (T-4)­' 784='Titanium tetrachloride' 
		785='Toluene-2,4-diisocyanate' 786='Toluene-2,6-diisocyanate' 
		787='Torpex' 788='Toxaphene' 
		789='trans-1,4-Dichloro-2-butene' 790='trans-1,4-Dichlorobutene' 
		791='Triallate' 792='Triamiphos' 
		793='Triazofos' 794='tribromide' 
		795='Trichloro(chloromethyl)silane' 796='Trichloro(dichlorophenyl)silane' 
		797='Trichloroacetyl chloride' 798='Trichloroethylsilane' 
		799='Trichloromethanesulfenyl chloride' 800='Trichloronate' 
		801='Trichlorophenylsilane' 802='Trichlorosilane' 
		803='Trichlorosilane' 804='Triethanolamine' 
		805='Triethanolamine hydrochloride' 806='Triethoxysilane' 
		807='Triethyl phosphate' 808='Trifluoroacetyl chloride' 
		809='trifluoroBoron' 810='Trifluorochloroethylene' 
		811='Trimethyl phosphate' 812='Trimethylamine' 
		813='Trimethylchlorosilane' 814='Trimethylolpropane phosphite' 
		815='Trimethyltin chloride' 816='Trinitroaniline' 
		817='Trinitroanisole' 818='Trinitrobenzene' 
		819='Trinitrobenzenesulfonic acid' 820='Trinitrobenzoic acid' 
		821='Trinitrochlorobenzene' 822='Trinitrofluorenone' 
		823='Trinitro-meta-cresol' 824='Trinitronaphthalene' 
		825='Trinitrophenetole' 826='Trinitrophenol' 
		827='Trinitroresorcinol' 828='Triphenyltin chloride' 
		829='Tris(2-chloroethyl)amine' 830='Tritonal' 
		831='Tungsten hexafluoride' 832='Uranium hexafluoride' 
		833='Valinomycin' 834='Vanadium pentoxide' 
		835='Vinyl acetate' 836='Vinyl acetate monomer' 
		837='Vinyl acetylene' 838='Vinyl chloride' 
		839='Vinyl ethyl ether' 840='Vinyl fluoride' 
		841='Vinyl methyl ether' 842='Vinylidene chloride' 
		843='Vinylidene fluoride' 844='Vinyltrichlorosilane' 
		845='VX' 846='Warfarin' 
		847='Warfarin sodium' 848='Xylene' 
		849='Xylylene dichloride' 850='Zinc hydrosulfite' 
		851='Zinc phosphide' 852='Zinc phosphide (conc. < = 10%)' 
		853='Zinc phosphide (conc. > 10%)' 854='Zinc, dichloro(4,4-dimethyl-5((((methylamino)carbonyl)oxy)imino)pentanenitrile)-, (T-4)­' 
		855='Ziram' 856='Sulfur (molten)' 
		857='Per- and Polyfluorinated Substances (PFAS)' 858='imidacloprid ((E)-1-(6-chloro-3-pyridylmethyl)-N-nitroimidazolidin-2-ylideneamine)' 
		859='Ferric Chloride (FeCl3)' 860='Zinc Orthophosphate (Zn3(PO4)2)' 
		861='Urea Ammonium Nitrate' 862='Diesel Exhaust Fluid' 
		863='Sodium Chromate';
	run;

/* import from csv file */
data c.chprs&year; %let _EFIERR_ = 0;
infile &csv_file  delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;

informat chprs_id $5. 
			county best12.
			date yymmdd10. 
			tot_chem best12. 
			relstyp best12.
			sub_typ best12.
			location best12.
			sub1 best12.
			sub1_oth $200. 
			sub2 best12.
			tot_vict best12. 
			comment $5000. ;

input
	chprs_id $
	county
	date
	tot_chem 
	relstyp 
	sub_typ 
	location 
	sub1 
	sub1_oth $
	sub2
	tot_vict 
	comment $ ;

format date date9.;

if _ERROR_ then call symput('_EFIERR_',"1");
run;


title1 'Missing values in Redcap';

title2 'Missing chprs_id';
proc sql number;
	select chprs_id, 
	county format=county_., 
	date, 
	tot_chem,
	relstyp format=relstyp_.,
	sub_typ format=sub_typ_.,
	location format=location_.,
	sub1 format=sub1_.,
	sub1_oth, 
	sub2 format=sub1_.,
	tot_vict, 
	comment
	from c.chprs&year
	where chprs_id is null
	order by chprs_id;
quit;
title2;

    proc odstext; 
        p "no missing values" / style=[fontsize=11pt fontfamily=Arial]; 
    run;

title2 'Missing county';
proc sql number;
   select 
    chprs_id, 
	county format=county_., 
	date, 
	tot_chem,
	relstyp format=relstyp_.,
	sub_typ format=sub_typ_.,
	location format=location_.,
	sub1 format=sub1_.,
	tot_vict, 
	comment
   from c.chprs&year
   where county not between 1 and 100
   order by chprs_id;
quit;
title2;

    proc odstext; 
        p "no missing values" / style=[fontsize=11pt fontfamily=Arial]; 
    run;


title2 'Missing date';
proc sql number;
   select chprs_id, 
	county format=county_., 
	date, 
	tot_chem,
	relstyp format=relstyp_.,
	sub_typ format=sub_typ_.,
	location format=location_.,
	sub1 format=sub1_.,
	tot_vict, 
	comment
   from c.chprs&year
   where date is null
   order by chprs_id;
quit;
title2;

    proc odstext; 
        p "no missing values" / style=[fontsize=11pt fontfamily=Arial]; 
    run;

title2 'Missing total chemicals';
proc sql number;
   select chprs_id, 
	county format=county_., 
	date, 
	tot_chem,
	relstyp format=relstyp_.,
	sub_typ format=sub_typ_.,
	location format=location_.,
	sub1 format=sub1_.,
	tot_vict, 
	comment
   from c.chprs&year
   where tot_chem is null
   order by chprs_id;
quit;
title2;


title2 'Missing release type';
proc sql number;
   select chprs_id, 
	county format=county_., 
	date, 
	tot_chem,
	relstyp format=relstyp_.,
	sub_typ format=sub_typ_.,
	location format=location_.,
	sub1 format=sub1_.,
	tot_vict, 
	comment
   from c.chprs&year
   where relstyp not between 1 and 7
   order by chprs_id;
quit;
title2;

    proc odstext; 
        p "no missing values" / style=[fontsize=11pt fontfamily=Arial]; 
    run;

title2 'Missing location';
proc sql number;
   select chprs_id, 
	county format=county_., 
	date, 
	tot_chem,
	relstyp format=relstyp_.,
	sub_typ format=sub_typ_.,
	location format=location_.,
	sub1 format=sub1_.,
	tot_vict, 
	comment
   from c.chprs&year
   where location not between 1 and 4
   order by chprs_id;
quit;
title2;

    proc odstext; 
        p "no missing values" / style=[fontsize=11pt fontfamily=Arial]; 
    run;

title2 'Missing substance type';
proc sql number;
   select chprs_id, 
	county format=county_., 
	date, 
	tot_chem,
	relstyp format=relstyp_.,
	sub_typ format=sub_typ_.,
	location format=location_.,
	sub1 format=sub1_.,
	tot_vict, 
	comment
   from c.chprs&year
   where sub_typ not between 1 and 4
   order by chprs_id;
quit;
title2;

    proc odstext; 
        p "no missing values" / style=[fontsize=11pt fontfamily=Arial]; 
    run;

title2 'Missing substance1';
proc sql number;
   select chprs_id, 
	county format=county_., 
	date, 
	tot_chem,
	relstyp format=relstyp_.,
	sub_typ format=sub_typ_.,
	location format=location_.,
	sub1 format=sub1_.,
	sub1_oth, 
	sub2 format=sub1_.,
	tot_vict, 
	comment
   from c.chprs&year
   where sub1 not between 1 and 863
   order by chprs_id;
quit;
title2;

title2 'Missing total victim';
proc sql number;
   select chprs_id, 
	county format=county_., 
	date, 
	tot_chem,
	relstyp format=relstyp_.,
	sub_typ format=sub_typ_.,
	location format=location_.,
	sub1 format=sub1_.,
	sub1_oth, 
	sub2 format=sub1_.,
	tot_vict, 
	comment
   from c.chprs&year
   where tot_vict is null
   order by chprs_id;
quit;
title2;

    /*proc odstext; 
        p "no missing values" / style=[fontsize=11pt fontfamily=Arial]; 
    run;*/
title;

/*Make analysis data set */
data c.ds&year;
	set c.chprs&year;
	
	/* derive new variables;
 extract month, year, weekday, etc. */
		incident_wkday = weekday(date);
		incident_month = month(date);
		incident_year = year(date);
	
/* label and format variables */
	label chprs_id='ChPRS ID Number:'
		 county='County:'
		 date='Date of incident:'
		 tot_chem='Total Number of Chemicals Spilled'
		 relstyp='Type of Release'
		 sub_typ='What type of substance was involved?'
		 location='What was the type of incident?'
		 sub1='Substance 1'
		 sub1_oth='Other and/or describe (please specify):'
		 sub2='Substance 2'
		 tot_vict='Total number of people injured:'
		 comment='Please provide a brief synopsis of the incident (ChPRS daily digest email body):'
		 incident_wkday = 'Day of incident'
		 incident_month = 'Month of incident'
		 incident_year = 'Year of incident';
	
	format 
		county county_. 
		relstyp relstyp_.
		sub_typ sub_typ_.
		location location_.
		sub1 sub1_.
		sub2 sub1_.
		date date9.;



/* format new variables */
	format 
		incident_wkday weekdate9.;
		
/* restrict to ChPRS eligible and complete incidents if needed */

run; 



ods pdf close;








