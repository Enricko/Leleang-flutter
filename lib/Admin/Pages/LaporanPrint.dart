// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/Api.dart';
import 'package:intl/intl.dart';
import '../../Api/ApiLelang.dart';

class LaporanPrint extends StatefulWidget {
  const LaporanPrint({super.key,required this.token});
  final String token;

  @override
  State<LaporanPrint> createState() => _LaporanPrintState();
}

class _LaporanPrintState extends State<LaporanPrint> {
  List<Data> lelang = [];
  @override
  void initState() {
    Api.LelangTable(widget.token, 'status=ditutup').then((value){
      lelang = value.data!;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Print Laporan Lelang')),
      body: PdfPreview(
        build: (format) => _generatePdf(format,lelang),
      ),
    );
  }
  Future<Uint8List> _generatePdf(PdfPageFormat format, List<Data> lelang) async {
    final currencyFormatter = NumberFormat('#,000', 'ID');
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();
    // final imagePath = 'http://127.0.0.1:8000/barang_lelang/';
    final dataLength = lelang.length;
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
            children: [
              pw.SizedBox(
                width: double.infinity,
                child: pw.FittedBox(
                  child: pw.Text('Laporan Lelang', style: pw.TextStyle(font: font,fontSize: 24)),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: const <int, pw.TableColumnWidth>{
                  0: pw.FixedColumnWidth(30),
                  1: pw.FixedColumnWidth(100),
                  2: pw.FlexColumnWidth(),
                  3: pw.FlexColumnWidth(),
                  4: pw.FlexColumnWidth(),
                },
                defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: [
                  pw.TableRow(
                    children: [
                      pw.Container(
                        padding: pw.EdgeInsets.all(5),
                        alignment: pw.Alignment.center,
                        child: pw.Text('No'),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(5),
                        alignment: pw.Alignment.center,
                        child: pw.Text('Nama Barang'),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(5),
                        alignment: pw.Alignment.center,
                        child: pw.Text('Penawar Tertinggi'),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(5),
                        alignment: pw.Alignment.center,
                        child: pw.Text('Penanggung Jawab(ID Petugas)'),
                      ),
                      pw.Container(
                        padding: pw.EdgeInsets.all(5),
                        alignment: pw.Alignment.center,
                        child: pw.Text('Harga Akhir'),
                      ),
                    ],
                  ),
                  for(var i = 0;i < (dataLength >= 8 ? 8 : dataLength) ; i++)
                  pw.TableRow(
                    children: [
                      pw.Container(
                        padding: pw.EdgeInsets.all(5),
                        alignment: pw.Alignment.center,
                        child: pw.Text('${i+1}'),
                      ),
                      pw.Container(
                        height: 50,
                        padding: pw.EdgeInsets.all(5),
                        alignment: pw.Alignment.center,
                        child: pw.Text('${lelang[i].barang!.namaBarang!}',textAlign: pw.TextAlign.center),
                      ),
                      pw.Container(
                        height: 50,
                        padding: pw.EdgeInsets.all(5),
                        alignment: pw.Alignment.center,
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            if(lelang[i].user!.id! == '') pw.Text('Barang Tidak Laku') else
                            pw.Container(
                              alignment: pw.Alignment.center,
                              child: pw.Text('${lelang[i].user!.name!} sadsdadsadasdasd',maxLines: 1,textAlign: pw.TextAlign.center),
                            ),
                            if(lelang[i].user!.id! == '')  pw.Container() else
                            pw.Text('(${lelang[i].user!.id!})'),
                          ]
                        ),
                      ),
                      pw.Container(
                        height: 50,
                        padding: pw.EdgeInsets.all(5),
                        alignment: pw.Alignment.center,
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text('${lelang[i].idPetugas!}'),
                          ]
                        ),
                      ),
                      pw.Container(
                        height: 50,
                        padding: pw.EdgeInsets.all(5),
                        alignment: pw.Alignment.center,
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            if(lelang[i].user!.id! == '') pw.Text('Barang Tidak Laku') else
                            pw.Text('Rp.${currencyFormatter.format(int.parse(lelang[i].barang!.hargaAkhir!))}'),
                          ]
                        ),
                      ),
                    ],
                  )
                ]
              )
            ],
          );
        },
      ),
    );

    if (dataLength > 9) {
      int loopPage = ((dataLength - 9) / 12).round();
      for (var p = 1; p <= loopPage + 4; p++) {
        var i =(p == 1 ? 9 : (9 + (12 * (p-1))));

        if(i >= dataLength){
          break;
        }
        pdf.addPage(
          pw.Page(
            pageFormat: format,
            build: (context) {
              return pw.Column(
                children: [
                  pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: const <int, pw.TableColumnWidth>{
                      0: pw.FixedColumnWidth(35),
                      1: pw.FlexColumnWidth(),
                      2: pw.FlexColumnWidth(),
                      3: pw.FlexColumnWidth(),
                      4: pw.FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(5),
                            alignment: pw.Alignment.center,
                            child: pw.Text('No'),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(5),
                            alignment: pw.Alignment.center,
                            child: pw.Text('Nama Barang'),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(5),
                            alignment: pw.Alignment.center,
                            child: pw.Text('Penawar Tertinggi'),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(5),
                            alignment: pw.Alignment.center,
                            child: pw.Text('Penanggung Jawab (ID Petugas)'),
                          ),
                          pw.Container(
                            padding: pw.EdgeInsets.all(5),
                            alignment: pw.Alignment.center,
                            child: pw.Text('Harga Akhir'),
                          ),
                        ],
                      ),
                      for(i;i < (9 + (12 * p) >= dataLength ? dataLength : 9 + (12 * p)); i++)
                      pw.TableRow(
                        children: [
                          pw.Container(
                            padding: pw.EdgeInsets.all(5),
                            alignment: pw.Alignment.center,
                            child: pw.Text('${i+1}'),
                          ),
                          pw.Container(
                            height: 50,
                            padding: pw.EdgeInsets.all(5),
                            alignment: pw.Alignment.center,
                            child: pw.Text('${lelang[i].barang!.namaBarang!}',textAlign: pw.TextAlign.center),
                          ),
                          pw.Container(
                            height: 50,
                            padding: pw.EdgeInsets.all(5),
                            alignment: pw.Alignment.center,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                if(lelang[i].user!.id! == '') pw.Text('Barang Tidak Laku') else
                                pw.Container(
                                  alignment: pw.Alignment.center,
                                  child: pw.Text('${lelang[i].user!.name!} sadsdadsadasdasd',maxLines: 1,textAlign: pw.TextAlign.center),
                                ),
                                if(lelang[i].user!.id! == '')  pw.Container() else
                                pw.Text('(${lelang[i].user!.id!})'),
                              ]
                            ),
                          ),
                          pw.Container(
                            height: 50,
                            padding: pw.EdgeInsets.all(5),
                            alignment: pw.Alignment.center,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                pw.Text('${lelang[i].idPetugas!}'),
                              ]
                            ),
                          ),
                          pw.Container(
                            height: 50,
                            padding: pw.EdgeInsets.all(5),
                            alignment: pw.Alignment.center,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              children: [
                                if(lelang[i].user!.id! == '') pw.Text('Barang Tidak Laku') else
                                pw.Text('Rp.${currencyFormatter.format(int.parse(lelang[i].barang!.hargaAkhir!))}'),
                              ]
                            ),
                          ),
                        ],
                      )
                    ]
                  )
                ],
              );
            },
          ),
        );
      }
    }
    return pdf.save();
  }
}