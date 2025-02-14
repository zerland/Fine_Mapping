// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppEigen.h>
#include <Rcpp.h>

using namespace Rcpp;

// calculateBayesFactorsRcpp
int calculateBayesFactorsRcpp(std::string zFilename, std::string corFilename, int priorType, std::vector<double> priorValues, int nSample, int maxCausal, std::string outputFile, bool exact, double eps, bool useIdentityMatrix);
RcppExport SEXP caviarbf_calculateBayesFactorsRcpp(SEXP zFilenameSEXP, SEXP corFilenameSEXP, SEXP priorTypeSEXP, SEXP priorValuesSEXP, SEXP nSampleSEXP, SEXP maxCausalSEXP, SEXP outputFileSEXP, SEXP exactSEXP, SEXP epsSEXP, SEXP useIdentityMatrixSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< std::string >::type zFilename(zFilenameSEXP);
    Rcpp::traits::input_parameter< std::string >::type corFilename(corFilenameSEXP);
    Rcpp::traits::input_parameter< int >::type priorType(priorTypeSEXP);
    Rcpp::traits::input_parameter< std::vector<double> >::type priorValues(priorValuesSEXP);
    Rcpp::traits::input_parameter< int >::type nSample(nSampleSEXP);
    Rcpp::traits::input_parameter< int >::type maxCausal(maxCausalSEXP);
    Rcpp::traits::input_parameter< std::string >::type outputFile(outputFileSEXP);
    Rcpp::traits::input_parameter< bool >::type exact(exactSEXP);
    Rcpp::traits::input_parameter< double >::type eps(epsSEXP);
    Rcpp::traits::input_parameter< bool >::type useIdentityMatrix(useIdentityMatrixSEXP);
    __result = Rcpp::wrap(calculateBayesFactorsRcpp(zFilename, corFilename, priorType, priorValues, nSample, maxCausal, outputFile, exact, eps, useIdentityMatrix));
    return __result;
END_RCPP
}
