#include <sstream> // Include this header for stringstream

void CalculateRatios( int irun, TString side = "", TString channel = "") 
{
  TFile *f=new TFile(TString::Format("work/qc_ZDC_MO_QcZDCRecTask_h_TDC_ZN%s_%s_A_%d.root",side.Data(), channel.Data(),irun));
  TH1 *h=(TH1*)gDirectory->Get("ccdb_object");

  TCanvas *c1 = new TCanvas("c1","c1",1);
  gPad->GetCanvas()->SetLogy();
  h->SetStats(0);
  double media = h->GetMean();
  h->GetXaxis()->SetRangeUser(2, 150);
  //h->SetTitle(TString::Format("Event time VS event position. Run %d",irun));
  h->GetXaxis()->SetTitle("ADC channels");
  h->GetYaxis()->SetTitle("counts");
  h->GetYaxis()->SetTitleOffset(1.2);
  gStyle->SetPalette(1,0);

  TF1 *fitFunc = new TF1("fitFunc", "[0]*exp(-x/[1]) + [2]*exp(-0.5*((x-[3])/[4])^2) + [5]*exp(-0.5*((x-[6])/[7])^2) + [8]*exp(-0.5*((x-[9])/[10])^2) + [11]*exp(-0.5*((x-[12])/[13])^2) + [14]*exp(-0.5*((x-[15])/[16])^2)", 12, 150);

  fitFunc->SetParName(0, "Exp_A");
  fitFunc->SetParName(1, "Exp_tau");
  fitFunc->SetParName(2, "G1_A");
  fitFunc->SetParName(3, "G1_mean");
  fitFunc->SetParName(4, "G1_sigma");
  fitFunc->SetParName(5, "G2_A");
  fitFunc->SetParName(6, "G2_mean");
  fitFunc->SetParName(7, "G2_sigma");
  fitFunc->SetParName(8, "G3_A");
  fitFunc->SetParName(9, "G3_mean");
  fitFunc->SetParName(10,"G3_sigma");
  fitFunc->SetParName(11,"G4_A");
  fitFunc->SetParName(12,"G4_mean");
  fitFunc->SetParName(13,"G4_sigma");
  fitFunc->SetParName(14,"G5_A");
  fitFunc->SetParName(15,"G5_mean");
  fitFunc->SetParName(16,"G5_sigma");

  fitFunc->SetParameter(0, 0.5*h->GetMaximum());          // Exp_A
  fitFunc->SetParameter(1, 75);             // Exp_tau

  fitFunc->SetParameter(2, 0.5*h->GetMaximum());          // CB1_A
  fitFunc->SetParameter(3, 31);              // CB1_mean
  fitFunc->SetParameter(4, 4);               // CB1_sigma

  fitFunc->SetParameter(5, 0.2*h->GetMaximum());          // CB2_A
  fitFunc->SetParameter(6, 70);              // CB2_mean
  fitFunc->SetParameter(7, 8);              // CB2_sigma

  //fitFunc->SetParameter(8, 0.1*h->GetMaximum());          // CB3_A
  fitFunc->SetParameter(9, 90);              // CB3_mean
  fitFunc->SetParameter(10, 9);              // CB3_sigma

  //fitFunc->SetParameter(11, 0.05*h->GetMaximum());          // CB4_A
  fitFunc->SetParameter(12, 120);              // CB4_mean
  fitFunc->SetParameter(13, 11);              // CB4_sigma

  //fitFunc->SetParameter(14, 0.05*h->GetMaximum());          // CB4_A
  fitFunc->SetParameter(15, 150);              // CB4_mean
  fitFunc->SetParameter(16, 15);              // CB4_sigma

  fitFunc->SetParLimits(0,  0, 0.8*h->GetMaximum());  // Exp_A
  fitFunc->SetParLimits(1, 50, 175);       // Exp_tau

  fitFunc->SetParLimits(2, 0, h->GetMaximum()); // CB1_A
  fitFunc->SetParLimits(3, 10, 50);          // CB1_mean
  fitFunc->SetParLimits(4, 3, 9);         // CB1_sigma

  fitFunc->SetParLimits(5, 0, h->GetMaximum());  // CB2_A
  fitFunc->SetParLimits(6, 50, 90);         // CB2_mean
  fitFunc->SetParLimits(7, 5, 15);        // CB2_sigma

  fitFunc->SetParLimits(8, 0, h->GetMaximum());  // CB3_A
  fitFunc->SetParLimits(9, 70, 110);         // CB3_mean
  fitFunc->SetParLimits(10, 5, 15);        // CB3_sigma

  fitFunc->SetParLimits(11, 0, h->GetMaximum());  // CB4_A
  fitFunc->SetParLimits(12, 100, 140);         // CB4_mean
  fitFunc->SetParLimits(13, 5, 15);        // CB4_sigma

  fitFunc->SetParLimits(14, 0, h->GetMaximum());  // CB4_A
  fitFunc->SetParLimits(15, 110, 170);         // CB4_mean
  fitFunc->SetParLimits(16, 10, 30);        // CB4_sigma

  h->Fit(fitFunc, "R");

  h->Draw();

  TLine *line = new TLine(fitFunc->GetParameter(3), h->GetMinimum(), fitFunc->GetParameter(3), h->GetMaximum());
  line->SetLineColor(kBlack); // Set line color to red
  line->SetLineWidth(3);    // Set line width
  line->Draw("same");


  std::ostringstream RunNumber;
  RunNumber << "Run number: " << irun;

  TText *text0 = new TText(95, h->GetMaximum(), RunNumber.str().c_str());
  text0->SetTextColor(kBlack);  // Set text color
  text0->SetTextSize(0.04);      // Set the text size
  text0->Draw();


  std::ostringstream position;
  position   << "1n position  : " << fitFunc->GetParameter(3);

  std::ostringstream sigma;
  sigma      << "1n sigma     : " << fitFunc->GetParameter(4);

  std::ostringstream resolution;
  resolution << "1n resolution: " << (fitFunc->GetParameter(4) / fitFunc->GetParameter(3))*100 << " %"; 

  TText *text1 = new TText(fitFunc->GetParameter(3)+2, h->GetMinimum()*8, position.str().c_str());
  text1->SetTextColor(kBlack);  // Set text color
  text1->SetTextSize(0.04);      // Set the text size
  text1->Draw();

  TText *text2 = new TText(fitFunc->GetParameter(3)+2, h->GetMinimum()*4, sigma.str().c_str());
  text2->SetTextColor(kBlack);  // Set text color
  text2->SetTextSize(0.04);      // Set the text size
  text2->Draw();

  TText *text3 = new TText(fitFunc->GetParameter(3)+2, h->GetMinimum()*2, resolution.str().c_str());
  text3->SetTextColor(kBlack);  // Set text color
  text3->SetTextSize(0.04);      // Set the text size
  text3->Draw();


  c1->Print(TString::Format("results/%d/1n/Peak1n_ZN%s_%s_%d.pdf",irun,side.Data(), channel.Data(),irun));
  c1->Close();
  f->Close();
}



void get_peak1n(int RunNumber = 0)
{	
    //gSystem->Exec("bash /home/Work/ZDC_Backgroud_Script/get_plot.bash");
    //TString output = gSystem->GetFromPipe("bash get_peak1n.bash");
    //int RunNumber = output.Atoi(); // Converte l'output in intero
    //std::cout << "Il numero intero passato dallo script è: " << RunNumber << std::endl;

	CalculateRatios(RunNumber,"A","TC");
	CalculateRatios(RunNumber,"A","SUM");
	CalculateRatios(RunNumber,"C","TC");
	CalculateRatios(RunNumber,"C","SUM");

  std::cout << "Done elaboratin Run: " << RunNumber << std::endl;
}