package org.eclipse.xtext.example.domainmodel.tests

import com.itemis.xtext.testing.XtextRunner2
import com.itemis.xtext.testing.XtextTest
import org.eclipse.xtext.example.domainmodel.DomainmodelInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

/**
 * This class demonstrates some of the features of XtextTest
 */
@RunWith(XtextRunner2)
@InjectWith(DomainmodelInjectorProvider)
class DemoXtextTest extends XtextTest {

	@Test def void demoTerminal() {
		// testTerminal can be used to ensure input is parsed to the
		// expected terminal rule
		testTerminal('1234', 'INT')

		// RULE_ is automatically added for terminal rules
		testTerminal('1234', 'INT')
		// For literal terminals, surround the rule name with single-quotes
		testTerminal('+', "'+'")

		// multiple terminals can be tested
		testTerminal('1234+4567', 'INT', "'+'", 'INT')

		try {
			// an incorrect terminal raises an assertion error
			testTerminal('1234', 'ID')
			fail('testTerminal was expected to raise an AssertionError')
		} catch (AssertionError e) {
			assertTrue(e.message.contains('expected:<RULE_I[D]> but was:<RULE_I[NT]>'))
		}

		try {
			// unexpected number of terminals raises an assertion error
			testTerminal('1234+4567', 'INT')
			fail('testTerminal was expected to raise an AssertionError')
		} catch (AssertionError e) {
			assertTrue(e.message.contains('expected:<1> but was:<3>'))
		}
	}

	@Test def void demoNotTerminal() {
		// testNotTerminal can be used to make input does not match
		// a given terminal rule exactly
		testNotTerminal('1234', 'ID')

		// it must be that only one rule is matched
		testNotTerminal('1234 4567', 'INT')

		// an unexpected match raises an assertion error
		try {
			testNotTerminal('1234', 'INT')
			fail('testNotTerminal was expected to raise an AssertionError')
		} catch (AssertionError e) {
			// there is no useful additional message
		}
	}

	@Test def void demoParserRuleErrors() {
		// with no rules to check, testParserRuleErrors passes as long
		// as there is some parse error
		testParserRuleErrors('''bad name''', 'QualifiedName')

		// A full, or partial error message can be checked
		testParserRuleErrors('''bad name''', 'QualifiedName', "extraneous input 'name' expecting EOF")
		testParserRuleErrors('''bad name''', 'QualifiedName', 'extraneous input')

		// Multiple error messages can be checked
		testParserRuleErrors('''package { } package two { bad }''', 'PackageDeclaration', "missing RULE_ID at '{'",
			"missing EOF at 'package'")

		try {
			// If a testParserRuleErrors fails to find an error an assertion
			// error is raised with details in the message
			testParserRuleErrors('''goodname''', 'QualifiedName')
			fail('testParserRuleErrors was expected to raise an AssertionError')
		} catch (AssertionError e) {
			assertTrue(e.message.contains('was expected to have parse errors'))
		}

		try {
			// If the wrong error is raised, an assertion error
			// is raised with details in the message
			testParserRuleErrors('''bad name''', 'QualifiedName', 'this error is not found')
			fail('testParserRuleErrors was expected to raise an AssertionError')
		} catch (AssertionError e) {
			assertTrue(e.message.contains('Unmatched assertions'))
			assertTrue(e.message.contains('Unasserted Errors'))
		}
	}
}
