#include <sstream> // Include this header for stringstream

void CalculateRatios( int irun, TString side = "", TString channel = "") 
{
  TFile *f=new TFile(TString::Format("work/qc_ZDC_MO_QcZDCRecTask_h_TDC_ZP%s_%s_A_%d.root",side.Data(), channel.Data(),irun));
  TH1 *h=(TH1*)gDirectory->Get("ccdb_object");

  TCanvas *c1 = new TCanvas("c1","c1",1);
  gPad->GetCanvas()->SetLogy();
  h->SetStats(0);
  double media = h->GetMean();
  h->GetXaxis()->SetRangeUser(2, 250);
  //h->SetTitle(TString::Format("Event time VS event position. Run %d",irun));
  h->GetXaxis()->SetTitle("ADC channels");
  h->GetYaxis()->SetTitle("counts");
  h->GetYaxis()->SetTitleOffset(1.2);
  gStyle->SetPalette(1,0);

  TF1 *fitFunc = new TF1("fitFunc", "[0]*exp(-x/[1]) + [2]*exp(-0.5*((x-[3])/[4])^2) + [5]*exp(-0.5*((x-[6])/[7])^2)", 15, 250);

  fitFunc->SetParName(0, "Exp_A");
  fitFunc->SetParName(1, "Exp_tau");
  fitFunc->SetParName(2, "G1_A");
  fitFunc->SetParName(3, "G1_mean");
  fitFunc->SetParName(4, "G1_sigma");
  fitFunc->SetParName(5, "G2_A");
  fitFunc->SetParName(6, "G2_mean");
  fitFunc->SetParName(7, "G2_sigma");

  fitFunc->SetParameter(0, 0.5*h->GetMaximum());          // Exp_A
  fitFunc->SetParameter(1, 125);             // Exp_tau
  fitFunc->SetParameter(2, 0.5*h->GetMaximum());          // CB1_A
  fitFunc->SetParameter(3, 17);              // CB1_mean
  fitFunc->SetParameter(4, 6);               // CB1_sigma
  fitFunc->SetParameter(5, 0.4*h->GetMaximum());          // CB2_A
  fitFunc->SetParameter(6, 73);              // CB2_mean
  fitFunc->SetParameter(7, 10);              // CB2_sigma

  fitFunc->SetParLimits(0,  0.2*h->GetMaximum(), 0.8*h->GetMaximum());  // Exp_A
  fitFunc->SetParLimits(1, 75, 175);       // Exp_tau
  fitFunc->SetParLimits(2, 0.2*h->GetMaximum(), 0.8*h->GetMaximum()); // CB1_A
  fitFunc->SetParLimits(3, 10, 30);          // CB1_mean
  fitFunc->SetParLimits(4, 3, 9);         // CB1_sigma
  fitFunc->SetParLimits(5, 0.1*h->GetMaximum(), 0.7*h->GetMaximum());  // CB2_A
  fitFunc->SetParLimits(6, 50, 100);         // CB2_mean
  fitFunc->SetParLimits(7, 5, 15);        // CB2_sigma

  h->Fit(fitFunc, "R");

  h->Draw();

  TLine *line = new TLine(fitFunc->GetParameter(6), h->GetMinimum(), fitFunc->GetParameter(6), h->GetMaximum());
  line->SetLineColor(kBlack); // Set line color to red
  line->SetLineWidth(3);    // Set line width
  line->Draw("same");

  std::ostringstream oss;
  oss << "1p position: " << fitFunc->GetParameter(6) << "  Run number: " << irun;

  TText *text = new TText(fitFunc->GetParameter(6), h->GetMaximum(), oss.str().c_str());
  text->SetTextColor(kBlack);  // Set text color
  text->SetTextSize(0.04);      // Set the text size
  text->Draw();


  c1->Print(TString::Format("results/%d/1p/Peak1p_ZP%s_%s_%d.pdf",irun,side.Data(), channel.Data(),irun));
  c1->Close();
  f->Close();
}


//MO_QcZDCRecTask_h_TDC_ZNA_SUM_V_559114.root


void get_peak1p()
{	
    //gSystem->Exec("bash /home/Work/ZDC_Backgroud_Script/get_plot.bash");
    TString output = gSystem->GetFromPipe("bash get_peak1p_plot.bash");
    int RunNumber = output.Atoi(); // Converte l'output in intero
    //std::cout << "Il numero intero passato dallo script è: " << RunNumber << std::endl;

	CalculateRatios(RunNumber,"A","TC");
	CalculateRatios(RunNumber,"A","SUM");
	CalculateRatios(RunNumber,"C","TC");
	CalculateRatios(RunNumber,"C","SUM");
}