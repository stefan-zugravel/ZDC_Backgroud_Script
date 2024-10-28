#include <sstream> // Include this header for stringstream

void CalculateRatios( int irun, TString side = "", TString channel = "") 
{
  TFile *f=new TFile(TString::Format("work/qc_ZDC_MO_QcZDCTask_hbunch-ZN%s_%s_T0_%d.root",side.Data(), channel.Data(),irun));
  TH2 *h=(TH2*)gDirectory->Get("ccdb_object");

  TCanvas *c1 = new TCanvas("c1","c1",1);
  gPad->GetCanvas()->SetLogy();
  //h->SetStats(0);
  //h->SetTitle(TString::Format("Event time VS event position. Run %d",irun));
  //h->GetXaxis()->SetTitle("ns");
  //h->GetYaxis()->SetTitle("counts");
  //h->GetYaxis()->SetTitleOffset(1.2);
  //gStyle->SetPalette(1,0);
  //h->Draw();


  //double nBinsTH1 = 100 * 36;
  double nBinsTH1 = 3564;
  TH1F *h1 = new TH1F("h1", "Istogramma 1D proiettato", nBinsTH1, -0.5, nBinsTH1-0.5);
  
  for (int binY = 1; binY <= 36; binY++) {
      for (int binX = 1; binX <= 100 ; binX++) {
          double content = h->GetBinContent(binX, binY);
          int binTH1 = (binY - 36) * -100 + (binX );
          h1->SetBinContent(binTH1, content);
      }
  }

  h1->SetStats(0);
  h1->SetTitle(TString::Format("BC events. Run %d",irun));
  h1->GetXaxis()->SetTitle("BC");
  h1->GetYaxis()->SetTitle("counts");
  h1->GetYaxis()->SetTitleOffset(1.2);
  //h1->Draw("HIST TEXT0");
  h1->Draw("HIST");


  c1->Print(TString::Format("results/%d/BC/BC_MAP_ZN%s_%s_%d.pdf",irun,side.Data(), channel.Data(),irun));
  c1->Close();
  f->Close();
}


//MO_QcZDCRecTask_h_TDC_ZNA_SUM_V_559114.root


void get_bcmap(int RunNumber = 0)
{	
	CalculateRatios(RunNumber,"A","TC_TR");
	CalculateRatios(RunNumber,"A","SUM");
	CalculateRatios(RunNumber,"C","TC_TR");
	CalculateRatios(RunNumber,"C","SUM");
    std::cout << "Done elaboratin Run: " << RunNumber << std::endl;
}