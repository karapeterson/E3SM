import os, shutil, tempfile

import acme_util
from acme_util import expect, warning

# Here are the tests belonging to acme suites. Format is
# <test>.<grid>.<compset>.
# suite_name -> (inherits_from, [testlist])
__TEST_SUITES = {
    "acme_tiny" : (None,
                   ["ERS.f19_g16_rx1.A",
                    "NCK.f19_g16_rx1.A"]
                   ),
    "acme_developer" : (None,
                        ['ERS.f19_g16_rx1.A',
                         'ERS.f45_g37.B1850C5',
                         'ERS.f45_g37_rx1.DTEST',
                         'ERS.ne30_g16_rx1.A',
                         'ERS_IOP.f19_g16_rx1.A',
                         'ERS_IOP.f45_g37_rx1.DTEST',
                         'ERS_IOP.ne30_g16_rx1.A',
                         'ERS_IOP4c.f19_g16_rx1.A',
                         'ERS_IOP4c.ne30_g16_rx1.A',
                         'ERS_IOP4p.f19_g16_rx1.A',
                         'ERS_IOP4p.ne30_g16_rx1.A',
                         'NCK.f19_g16_rx1.A',
                         'PEA_P1_M.f45_g37_rx1.A',
                         'SMS.ne30_f19_g16_rx1.A',
                         'SMS.f19_f19.I1850CLM45CN']
                        ),
    "acme_integration" : ("acme_developer",
                          ["ERB.f19_g16.B1850C5",
                           "ERB.f45_g37.B1850C5",
                           "ERH.f45_g37.B1850C5",
                           "ERS.f09_g16.B1850C5",
                           "ERS.f19_f19.FAMIPC5",
                           "ERS.f19_g16.B1850C5",
                           "ERS_D.f45_g37.B1850C5",
                           "ERS_IOP_Ld3.f19_f19.FAMIPC5",
                           "ERS_Ld3.f19_g16.FC5",
                           "ERS_Ld3.ne30_ne30.FC5",
                           "ERT.f19_g16.B1850C5",
                           "PET_PT.f19_g16.X",
                           "PET_PT.f45_g37_rx1.A",
                           "PFS.ne30_ne30.FC5",
                           "SEQ_IOP_PFC.f19_g16.X",
                           "SEQ_PFC.f45_g37.B1850C5",
                           "SMS.ne16_ne16.FC5AQUAP",
                           "SMS_D.f19_g16.B20TRC5",
                           "SMS_D_Ld3.f19_f19.FC5"]
                          ),
}

###############################################################################
def get_test_suite(suite):
###############################################################################
    expect(suite in __TEST_SUITES, "Unknown test suite: '%s'" % suite)
    inherits_from, tests = __TEST_SUITES[suite]
    if (inherits_from is not None):
        inherited_tests = get_test_suite(inherits_from)
        expect(len(set(tests) & set(inherited_tests)) == 0,
               "Tests %s defined in multiple suites" % ", ".join(set(tests) & set(inherited_tests)))
        tests.extend(inherited_tests)
    return tests

###############################################################################
def get_test_suites():
###############################################################################
    return __TEST_SUITES.keys()

###############################################################################
def find_all_platforms(xml_file):
###############################################################################
    f = open(xml_file, 'r')
    lines = f.readlines()
    f.close()
    platform_set = set()

    for line in lines:
        if '<machine' in line:
            i1 = line.index('compiler') + len('compiler="')
            i2 = line.index('"', i1)
            compiler = line[i1:i2]
            j1 = line.index('>') + 1
            j2 = line.index('<', j1)
            machine = line[j1:j2]
            platform_set.add((machine, compiler))

    return list(platform_set)

###############################################################################
def replace_testlist_xml(output, xml_file):
###############################################################################
    # manage_xml_entries creates a temporary file intended for people to manually check the
    # changes. This made sense before revision control, but not anymore.
    if 'now writing the new test list to' in output:
        i1 = output.index('now writing') + len('now writing the new test list to ')
        i2 = output.index('xml') + 3
        new_xml_file = output[i1:i2]
        shutil.move(new_xml_file, xml_file)

###############################################################################
def generate_acme_test_entries(category, platforms):
###############################################################################
    tests = get_test_suite(category)
    test_file = tempfile.NamedTemporaryFile(mode='w', delete = False)
    for test in tests:
        for machine, compiler in platforms:
            test_file.write('%s.%s_%s\n'%(test, machine, compiler))
    name = test_file.name
    test_file.close()
    return name

###############################################################################
def update_acme_test(xml_file, category, platform):
###############################################################################
    # Fish all of the existing machine/compiler combos out of the XML file.
    if (platform is not None):
        platforms = [tuple(platform.split(","))]
    else:
        platforms = find_all_platforms(xml_file)

    # Try to find the manage_xml_entries script. Assume sibling of xml_file
    manage_xml_entries = os.path.join(os.path.dirname(xml_file), "manage_xml_entries")
    expect(os.path.isfile(manage_xml_entries),
           "Couldn't find manage_xml_entries, expect sibling of '%s'" % xml_file)

    # Remove any existing acme test category from the file.
    if (platform is None):
        output = acme_util.run_cmd('%s -removetests -category %s' % (manage_xml_entries, category))
    else:
        output = acme_util.run_cmd('%s -removetests -category %s -machine %s -compiler %s'
                                   % (manage_xml_entries, category, platforms[0][0], platforms[0][1]))
    replace_testlist_xml(output, xml_file)

    # Generate a list of test entries corresponding to our suite at the top
    # of the file.
    new_test_file = generate_acme_test_entries(category, platforms)
    output = acme_util.run_cmd("%s -addlist -file %s -category %s" %
                               (manage_xml_entries, new_test_file, category))
    os.unlink(new_test_file)
    replace_testlist_xml(output, xml_file)
