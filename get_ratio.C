#include <sstream> // Include this header for stringstream

void CalculateRatios( int irun, TString side = "", TString channel = "") 
{
  TFile *f=new TFile(TString::Format("work/qc_ZDC_MO_QcZDCRecTask_h_TDC_ZN%s_%s_V_%d.root",side.Data(), channel.Data(),irun));
  TH1 *h=(TH1*)gDirectory->Get("ccdb_object");

  TCanvas *c1 = new TCanvas("c1","c1",1);
  gPad->GetCanvas()->SetLogy();
  h->SetStats(0);
  double media = h->GetMean();
  //h->SetTitle(TString::Format("Event time VS event position. Run %d",irun));
  h->GetXaxis()->SetTitle("ns");
  h->GetYaxis()->SetTitle("counts");
  h->GetYaxis()->SetTitleOffset(1.2);
  gStyle->SetPalette(1,0);
  h->Draw();
  int bin_low = h->FindBin(-3 + media);
  int bin_max = h->FindBin(3 + media);
  int BIN_low = h->FindBin(5.5 + media);
  int BIN_max = h->FindBin(9.5 + media);
  int BIN2_low = h->FindBin(-11.5 + media);
  int BIN2_max = h->FindBin(-8.5 + media);
  std::cout << "===================== ZN" << TString::Format("%s_%s_%d",side.Data(), channel.Data(),irun) << " ====================="<< std::endl;
  double integralMain   = h->Integral(bin_low, bin_max);
  double integralNoise  = h->Integral(BIN_low, BIN_max);
  double integralNoise2 = h->Integral(BIN2_low, BIN2_max);
  double ratio  = 100*(integralNoise/integralMain);
  double ratio2 = 100*(integralNoise2/integralMain);
  std::cout << "Valor medio   : " << media << std::endl;
  std::cout << "Integrating from " << -3 + media << " and " << 3 + media << std::endl;
  std::cout << "integralMain  : " << integralMain << std::endl;
  std::cout << "Integrating from " << 5.5 + media << " and " << 9.5 + media << std::endl;
  std::cout << "integralNoise : " << integralNoise << std::endl;
  std::cout << "Integrating from " << -11.5 + media << " and " << -8.5 + media << std::endl;
  std::cout << "integralNoise2: " << integralNoise2 << std::endl;  
  std::cout << "ratio         : " << ratio << " %" << std::endl;
  std::cout << "ratio2        : " << ratio2 << " %" << std::endl;

  TLine *line0 = new TLine(-3 + media, h->GetMinimum(), -3 + media, h->GetMaximum()/2);
  line0->SetLineColor(kRed); // Set line color to red
  line0->SetLineWidth(3);    // Set line width
  line0->Draw("same");

  TLine *line1 = new TLine(3 + media, h->GetMinimum(), 3 + media, h->GetMaximum()/2);
  line1->SetLineColor(kRed); // Set line color to red
  line1->SetLineWidth(3);    // Set line width
  line1->Draw("same");

  TLine *line2 = new TLine(5.5 + media, h->GetMinimum(), 5.5 + media, h->GetMaximum()/2);
  line2->SetLineColor(kBlue); // Set line color to red
  line2->SetLineWidth(3);    // Set line width
  line2->Draw("same");

  TLine *line3 = new TLine(9.5 + media, h->GetMinimum(), 9.5 + media, h->GetMaximum()/2);
  line3->SetLineColor(kBlue); // Set line color to red
  line3->SetLineWidth(3);    // Set line width
  line3->Draw("same");

  TLine *line4 = new TLine(-11.5 + media, h->GetMinimum(), -11.5 + media, h->GetMaximum()/2);
  line4->SetLineColor(kBlack); // Set line color to red
  line4->SetLineWidth(3);    // Set line width
  line4->Draw("same");

  TLine *line5 = new TLine(-8.5 + media, h->GetMinimum(), -8.5 + media, h->GetMaximum()/2);
  line5->SetLineColor(kBlack); // Set line color to red
  line5->SetLineWidth(3);    // Set line width
  line5->Draw("same");

  std::ostringstream oss;
  oss << "Ratio R: " << ratio << " %   Run number: " << irun;

  TText *text = new TText(-12, h->GetMaximum(), oss.str().c_str());
  text->SetTextColor(kBlack);  // Set text color
  text->SetTextSize(0.04);      // Set the text size
  text->Draw();

  std::ostringstream oss2;
  oss2 << "Ratio L: " << ratio2 << " % ";

  TText *text2 = new TText(-12, h->GetMaximum()/2, oss2.str().c_str());
  text2->SetTextColor(kBlack);  // Set text color
  text2->SetTextSize(0.04);      // Set the text size
  text2->Draw();


  c1->Print(TString::Format("results/%d/ratio/Background_study_ZN%s_%s_%d.pdf",irun,side.Data(), channel.Data(),irun));
  c1->Close();
  f->Close();
}


//MO_QcZDCRecTask_h_TDC_ZNA_SUM_V_559114.root


void get_ratio(int RunNumber = 0)
{	
    //gSystem->Exec("bash /home/Work/ZDC_Backgroud_Script/get_plot.bash");
    //TString output = gSystem->GetFromPipe("bash get_ratio.bash");
    //int RunNumber = output.Atoi(); // Converte l'output in intero
    //std::cout << "Il numero intero passato dallo script è: " << RunNumber << std::endl;

	CalculateRatios(RunNumber,"A","TC");
	CalculateRatios(RunNumber,"A","SUM");
	CalculateRatios(RunNumber,"C","TC");
	CalculateRatios(RunNumber,"C","SUM");

  std::cout << "Done elaboratin Run: " << RunNumber << std::endl;
}