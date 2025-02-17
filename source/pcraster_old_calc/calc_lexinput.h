#ifndef  INCLUDED_CALC_LEXINPUT
#define INCLUDED_CALC_LEXINPUT

#ifndef INCLUDED_OSTREAM
#include <iostream>
#define INCLUDED_OSTREAM
#endif
#ifndef INCLUDED_VECTOR
#include <vector>
#define INCLUDED_VECTOR
#endif
#ifndef INCLUDED_STRING
#include <string>
#define INCLUDED_STRING
#endif

#ifndef INCLUDED_BOOST_SHARED_PTR
#include <boost/shared_ptr.hpp>
#define INCLUDED_BOOST_SHARED_PTR
#endif

namespace com {
  class PathName;
}

namespace calc {

class LexInputSource;
class Position;

//! input object for use in script lexer/parser
/*! LexInput implements a character stream initiated from
 *  either an input (script) file or a statement from the command line.
 *  It also implements the shell-$ substitution
 *  <BR>Still to do<UL>
 *  <LI>Make InstallCommandLineScript and InstallScript ctor's to elimnate d_from
 *      that could now be intialized more then once
 *  <LI>rewrite shell subst.
 *  </UL>
 */
class LexInput {
private:
  /*! file being read,
   *  empty string when reading a command line
   */
  boost::shared_ptr<std::string> d_currentFileName;

  //! last call to GetChar return newline
  bool d_prevCallWasNewLine{false};
  //! last call to GetChar is in comment
  bool d_gettingInComment{false};

  //! line nr is kept
  int d_lineNr{1};
  //! char nr  relative to beginning of line, begin of token
  int d_tokenStart{1};

  //! buffer used to parse macro
  std::string d_expInBuf;

  //! buffer used to store expanded macro's and feed it to parser
  std::string d_expOutBuf;
  /*! next char to feed, if not a valid index then do not feed
      from d_expOutBuf;
   */
  size_t   d_ptrExpOutBuf;

  LexInputSource *d_from{nullptr};

  std::vector<std::string> d_shellArgs;

  int    d_extraCharRead{EOF};
  bool   d_substitution{true};

  int getRawChar();
  char getRawCharEOFcheck();
  int getParameterNr(      const std::string& name, bool nIsShellArg);
  std::string getParameter(const std::string& name, bool bracePresent);

  void parseShellParamUse();
public:
  LexInput();
  ~LexInput();

  void printExpandedCode(std::ostream& outStream);
  void installArgvScript(int argC, const char **argV,bool substitution=true);
  void installFileScript(const com::PathName& fileName);
  void installStringScript(const char *str);
  void installShellArgs(int nrShellArgs_in, const char **argV);

  int       getChar();
  void      incrCharNr(size_t len) { d_tokenStart += len; }

  Position *createPosition() const;
  bool      substitutionOn() const { return d_substitution; }
};


}

#endif
