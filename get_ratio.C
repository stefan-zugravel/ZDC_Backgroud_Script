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
  std::cout << "===================== ZN" << TString::Format("%s_%s_%d",side.Data(), channel.Data(),irun) << " ====================="<< std::endl;
  double integralMain  = h->Integral(bin_low, bin_max);
  double integralNoise = h->Integral(BIN_low, BIN_max);
  double ratio = 100*(integralNoise/integralMain);
  std::cout << "Valor medio  : " << media << std::endl;
  std::cout << "Integrating from " << -3 + media << " and " << 3 + media << std::endl;
  std::cout << "integralMain : " << integralMain << std::endl;
  std::cout << "Integrating from " << 5.5 + media << " and " << 9.5 + media << std::endl;
  std::cout << "integralNoise: " << integralNoise << std::endl;
  std::cout << "ratio        : " << ratio << " %" << std::endl;

  TLine *line0 = new TLine(-3 + media, h->GetMinimum(), -3 + media, h->GetMaximum());
  line0->SetLineColor(kRed); // Set line color to red
  line0->SetLineWidth(3);    // Set line width
  line0->Draw("same");

  TLine *line1 = new TLine(3 + media, h->GetMinimum(), 3 + media, h->GetMaximum());
  line1->SetLineColor(kRed); // Set line color to red
  line1->SetLineWidth(3);    // Set line width
  line1->Draw("same");

  TLine *line2 = new TLine(5.5 + media, h->GetMinimum(), 5.5 + media, h->GetMaximum());
  line2->SetLineColor(kBlue); // Set line color to red
  line2->SetLineWidth(3);    // Set line width
  line2->Draw("same");

  TLine *line3 = new TLine(9.5 + media, h->GetMinimum(), 9.5 + media, h->GetMaximum());
  line3->SetLineColor(kBlue); // Set line color to red
  line3->SetLineWidth(3);    // Set line width
  line3->Draw("same");

  std::ostringstream oss;
  oss << "Ratio: " << ratio << " %   Run number: " << irun;

  TText *text = new TText(-12, h->GetMaximum(), oss.str().c_str());
  text->SetTextColor(kBlack);  // Set text color
  text->SetTextSize(0.04);      // Set the text size
  text->Draw();


  c1->Print(TString::Format("%d/Background_study_ZN%s_%s_%d.pdf",irun,side.Data(), channel.Data(),irun));
  c1->Close();
  f->Close();
}


//MO_QcZDCRecTask_h_TDC_ZNA_SUM_V_559114.root


void get_ratio()
{	
    //gSystem->Exec("bash /home/stefan/Desktop/ZDC_Backgroud_Script/get_plot.bash");
    TString output = gSystem->GetFromPipe("bash /home/stefan/Desktop/ZDC_Backgroud_Script/get_plot.bash");
    int RunNumber = output.Atoi(); // Converte l'output in intero
    //std::cout << "Il numero intero passato dallo script è: " << RunNumber << std::endl;

	CalculateRatios(RunNumber,"A","TC");
	CalculateRatios(RunNumber,"A","SUM");
	CalculateRatios(RunNumber,"C","TC");
	CalculateRatios(RunNumber,"C","SUM");
}